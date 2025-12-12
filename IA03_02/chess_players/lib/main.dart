import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:chess_players/widgets/player_card.dart';
import 'package:chess_players/entities/player.dart';
import 'package:chess_players/api_services/get_players_service.dart';
import 'package:chess_players/pages/custom_player.dart';
import 'package:chess_players/pages/search_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color chessGreen = Color.fromARGB(255, 120, 186, 73);
    const Color darkBackground = Color.fromARGB(255, 34, 35, 32);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MaterialApp(
        title: 'Chess.com Players - Salesians de Sarrià 2526 ',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: chessGreen,
          scaffoldBackgroundColor: darkBackground,
          cardColor: const Color.fromARGB(255, 45, 46, 43),
          colorScheme: ColorScheme.fromSeed(
            seedColor: chessGreen,
            brightness: Brightness.dark,
            background: darkBackground,
            surface: const Color.fromARGB(255, 45, 46, 43),
            onSurface: Colors.white,
            primary: chessGreen,
          ).copyWith(secondary: chessGreen),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(255, 26, 20, 13),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: chessGreen,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          textTheme: Typography.whiteMountainView.apply(
            bodyColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Chess.com Wiki Players - Damian Altamirano O.';
  final List<String> usernamesList = ['hikaru', 'magnuscarlsen'];
  late Future<List<Player>> playersFuture;
  List<Player> _players = [];

  void _handleCardTap(Player player) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerDetailScreen(player: player),
      ),
    );
    setState(() {}); // Refresca la lista al volver
  }

  void _handleFavoriteToggle(Player player) {
    setState(() {
      player.isFavorite = !player.isFavorite;

      if (player.isFavorite) {
        player.followers += 1;
      } else {
        player.followers -= 1;
      }
    });
  }

  Color _getLeagueColor(String league) {
    // Aseguramos que la comparación no distinga mayúsculas y minúsculas
    switch (league.toLowerCase()) {
      case 'legend':
        // Color que simula el Oro/Leyenda (Amarillo intenso)
        return const Color.fromARGB(255, 183, 183, 183);
      case 'champion':
        // Color para Campeón (Rojo/Borgoña)
        return const Color.fromARGB(255, 207, 169, 0);
      case 'elite':
        // Color para Elite (Cian/Azul Brillante)
        return const Color.fromARGB(255, 154, 0, 0);
      case 'crystal':
        // Color para Cristal (Azul claro/Acuático)
        return Colors.blue.shade400;
      case 'silver':
        // Color para Plata (Gris claro/Plateado)
        return Colors.blueGrey.shade300;
      case 'bronze':
        // Color para Bronce (Marrón/Naranja oscuro)
        return const Color.fromARGB(255, 161, 94, 27);
      case 'stone':
        // Color para Piedra (Gris piedra oscuro)
        return Colors.grey.shade700;
      case 'wood':
        // Color para Madera (Marrón base)
        return Colors.brown.shade800;
      default:
        // Color por defecto si la liga no coincide, usando el cardColor original del tema.
        return Theme.of(context).cardColor;
    }
  }

  Future<List<Player>> _loadInitialPlayers() async {
    final players = await PlayersApiService.fetchPlayers(usernamesList);
    setState(() {
      _players = players;
    });
    return players;
  }

  @override
  void initState() {
    super.initState();
    playersFuture = _loadInitialPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 34, 27, 23),
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPlayer = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PlayerSearchScreen()),
          );
          if (newPlayer != null && newPlayer is Player) {
            setState(() {
              _players.add(newPlayer);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Jugador ${newPlayer.username} añadido!')),
            );
          }
        },
        child: const Icon(Icons.search),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Player>>(
        future: playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return MasonryGridView.count(
            padding: const EdgeInsets.all(12),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 2,
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];

              return PlayerCard(
                player: player,
                onCardTap: _handleCardTap,
                onFavoriteToggle: _handleFavoriteToggle,
                cardColor: _getLeagueColor(player.league),
              );
            },
          );
        },
      ),
    );
  }
}
