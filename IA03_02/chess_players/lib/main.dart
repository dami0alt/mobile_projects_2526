import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:chess_players/entities/player.dart';
import 'package:chess_players/pages/custom_player.dart';
import 'package:chess_players/pages/search_player.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color chessGreen = Color.fromARGB(255, 120, 186, 73);
    const Color darkBackground = Color.fromARGB(255, 34, 35, 32);
    return MaterialApp(
      title: 'M0489 - Apps - Form (A)',
      theme: ThemeData(
        // 1. Usar el brillo oscuro como base
        brightness: Brightness.dark,

        // 2. Color primario/de acento (para botones, FAB, etc.)
        primaryColor: chessGreen,

        // 3. Color de fondo general de la pantalla (Scaffold)
        scaffoldBackgroundColor: darkBackground,

        // 4. Color de fondo de los Cards
        cardColor: const Color.fromARGB(255, 45, 46, 43),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: chessGreen,
              brightness: Brightness.dark,
              background: darkBackground,
              surface: const Color.fromARGB(
                255,
                45,
                46,
                43,
              ), // Superficies como Cards
              onSurface: Colors.white,
              primary: chessGreen,
            ).copyWith(
              secondary:
                  chessGreen, // Color secundario para FloatingActionButton, etc.
            ),

        // 6. Estilo del AppBar (para que se fusione con el fondo)
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 26, 20, 13),
          foregroundColor: Colors.white, // Color del texto y los iconos
          elevation: 0, // Sin sombra para un look plano
        ),

        // 7. Estilo de botones elevados (como Sign Up)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: chessGreen,
            foregroundColor: Colors.black, // Texto negro sobre fondo verde
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // 8. Estilo de texto por defecto
        textTheme: Typography.whiteMountainView.apply(bodyColor: Colors.white),

        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Chess.com Wiki Players';

  final List<String> usernamesList = [
    'darco8987',
    'Carnicerooii',
    'hikaru',
    'magnuscarlsen',
  ];

  late Future<List<Player>> playersFuture;
  List<Player> _players = [];

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
    final players = await PlayersApiService.getPlayer(usernamesList);
    setState(() {
      _players = players; // Inicializa la lista local
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
          // Navegar a la pantalla de búsqueda y esperar el resultado (el Player encontrado)
          final newPlayer = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PlayerSearchScreen()),
          );

          // Si se devuelve un Player (no nulo)
          if (newPlayer != null && newPlayer is Player) {
            setState(() {
              _players.add(newPlayer); // Añadir el nuevo jugador a la lista
            });
            // Opcional: Mostrar una confirmación
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

          //final players = snapshot.data!;

          return MasonryGridView.count(
            padding: const EdgeInsets.all(12),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 2,
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];

              return InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlayerDetailScreen(player: player),
                    ),
                  );
                  setState(() {});
                },

                child: Card(
                  elevation: 4,
                  color: _getLeagueColor(player.league),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'player-avatar-${player.username}',
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(player.avatar),
                          ),
                        ),
                        const SizedBox(height: 12),
                        RatingBar.builder(
                          initialRating: player.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        const SizedBox(height: 12),
                        // ⭐ Username dinámico (altura variable)
                        Text(
                          player.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 6),

                        Text("🌍 ${player.country}"),
                        Text("⭐ Status: ${player.status}"),
                        Text("🏆 League: ${player.league}"),

                        const SizedBox(height: 10),

                        // Followers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.people, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              player.followers.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        IconButton(
                          icon: Icon(
                            player.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: player.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              player.isFavorite = !player.isFavorite;

                              if (player.isFavorite) {
                                player.followers += 1;
                              } else {
                                player.followers -= 1;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
