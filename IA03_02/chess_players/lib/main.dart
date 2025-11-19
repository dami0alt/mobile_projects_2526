import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chess_players/entities/player.dart';
import 'package:chess_players/providers/chess_player.dart';

void main() {
  runApp(
    // 1. Configurar el ChangeNotifierProvider para PlayerStore
    ChangeNotifierProvider(
      create: (context) => PlayerStore(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Cargar los datos inmediatamente al iniciar la app
    // Usamos Future.microtask para evitar llamar a notifyListeners durante el build inicial.
    Future.microtask(() => context.read<PlayerStore>().loadPlayers());

    return MaterialApp(
      title: 'Top Chess Players',
      theme: ThemeData(primarySwatch: Colors.blueGrey, useMaterial3: true),
      home: const PlayerListScreen(),
    );
  }
} // 3. Widget de la lista de jugadores usando Consumer

class PlayerListScreen extends StatelessWidget {
  const PlayerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Top Players (The HiveStock Project)'),
        backgroundColor: Colors.blueGrey,
      ),
      // ⚠️ Un junior a menudo usará Consumer para escuchar el estado,
      // aunque Provider.select o context.watch/read son más eficientes.
      body: Consumer<PlayerStore>(
        builder: (context, store, child) {
          if (store.players.isEmpty) {
            // 🔄 Muestra un indicador de carga mientras los datos están vacíos
            return const Center(child: CircularProgressIndicator());
          }

          // 4. Muestra la lista con los datos cargados
          return ListView.builder(
            itemCount: store.players.length,
            itemBuilder: (context, index) {
              final player = store.players[index];
              // 5. Muestra los detalles del jugador
              return PlayerListItem(player: player);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// 6. Widget para cada elemento de la lista
class PlayerListItem extends StatelessWidget {
  final Player player;
  const PlayerListItem({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    // 7. Acceder a las customizaciones (ejemplo de uso de getCustomization)
    final customData = context.read<PlayerStore>().getCustomization(
      player.username,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      elevation: 4.0,
      child: ListTile(
        leading: CircleAvatar(
          // 🖼️ Mostrar el avatar del jugador
          backgroundImage: NetworkImage(player.avatar),
        ),
        title: Text(
          '${player.username} ${customData.isFavorite ? '⭐' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Nombre: ${player.name} | Seguidores: ${player.followers}',
        ),
        trailing: IconButton(
          icon: Icon(
            customData.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: customData.isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            // 👆 Función de ejemplo para actualizar la customización
            final store = context.read<PlayerStore>();
            store.updateCustomization(
              player.username,
              CustomPlayerData(isFavorite: !customData.isFavorite),
            );
          },
        ),
        onTap: () {
          // 🖱️ Lógica para navegar a la pantalla de detalle (no implementada)
          print('Tap en ${player.username}');
        },
      ),
    );
  }
}
