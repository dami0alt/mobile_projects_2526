import 'package:flutter/material.dart';
import 'package:chess_players/entities/player.dart';

class SearchResultCard extends StatelessWidget {
  final Player player;
  final VoidCallback onAdd;

  const SearchResultCard({
    super.key,
    required this.player,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Añadir a la Lista Principal'),
            ),
          ],
        ),
      ),
    );
  }
}
