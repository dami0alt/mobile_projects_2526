import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:chess_players/entities/player.dart';
import 'package:chess_players/pages/custom_player.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    if (username.isEmpty) return;

    setState(() {
      _isLoading = true;
      _foundPlayer = null;
      _errorMessage = null;
    });

    try {
      // PlayersApiService.getPlayer espera una lista, aunque solo busquemos uno
      final players = await PlayersApiService.getPlayer([username]);

      setState(() {
        if (players.isNotEmpty) {
          _foundPlayer = players.first;
          _errorMessage = null;
        } else {
          // Esto puede ocurrir si la API devuelve 200 pero la lista está vacía
          _errorMessage = 'Jugador no encontrado.';
        }
      });
    } catch (e) {
      // Manejo de errores (por ejemplo, 404 Not Found o fallo de red)
      setState(() {
        _errorMessage =
            'Error al buscar el jugador: Asegúrate de que el nombre de usuario es correcto.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addPlayerToList() {
    if (_foundPlayer != null) {
      // Devolver el jugador encontrado a la pantalla anterior
      Navigator.pop(context, _foundPlayer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Jugador'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nombre de Usuario de Chess.com',
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
            ),

            const SizedBox(height: 20),

            // Mostrar resultados o errores
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

            if (_foundPlayer != null)
              // Tarjeta del Jugador Encontrado (Reutiliza tu diseño)
              _buildFoundPlayerCard(context),
          ],
        ),
      ),
    );
  }

  // ⭐ NUEVO: Widget para mostrar la tarjeta del jugador encontrado
  Widget _buildFoundPlayerCard(BuildContext context) {
    final player = _foundPlayer!;
    return Card(
      color: Theme.of(context).cardColor, // Usa el color base de la tarjeta
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(player.avatar),
            ),
            const SizedBox(height: 10),
            Text(
              player.username,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Nombre: ${player.name}'),
            Text('Liga: ${player.league}'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addPlayerToList,
              icon: const Icon(Icons.add),
              label: const Text('Añadir a la Lista Principal'),
            ),
          ],
        ),
      ),
    );
  }
}
