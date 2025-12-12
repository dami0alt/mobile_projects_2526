import 'package:flutter/material.dart';

import 'package:chess_players/api_services/get_players_service.dart';
import 'package:chess_players/entities/player.dart';
import 'package:chess_players/widgets/search_result_card.dart';

class PlayerSearchScreen extends StatefulWidget {
  const PlayerSearchScreen({super.key});

  @override
  State<PlayerSearchScreen> createState() => _PlayerSearchScreenState();
}

class _PlayerSearchScreenState extends State<PlayerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Player? _foundPlayer;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchPlayer(String username) async {
    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Insert an username';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _foundPlayer = null;
      _errorMessage = null;
    });

    try {
      final Player player = await PlayersApiService.fetchSinglePlayer(username);

      setState(() {
        _foundPlayer = player;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: Player not found';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addPlayerToList() {
    if (_foundPlayer != null) {
      Navigator.pop(context, _foundPlayer);
    }
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Chess.com User name',
        suffixIcon: _isLoading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _searchPlayer(_searchController.text),
              ),
        border: const OutlineInputBorder(),
      ),
      onSubmitted: _searchPlayer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Player'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSearchField(),

            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

            if (_foundPlayer != null)
              SearchResultCard(player: _foundPlayer!, onAdd: _addPlayerToList),
          ],
        ),
      ),
    );
  }
}
