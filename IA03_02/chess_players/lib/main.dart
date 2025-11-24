import 'package:flutter/material.dart';
import 'package:chess_players/entities/player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Player>> futurePlayers;

  @override
  void initState() {
    super.initState();
    futurePlayers = PlayersService.getPlayer([
      'darco8987',
      'hikaru',
      'magnuscarlsen',
      'fabianocaruana',
      'alirezafirouzja2003',
      'wesleyso',
      'anishgiri',
      'danielnaroditsky',
      'gothamchess',
      'ericrosen',
      'gmjune',
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chess Players"), centerTitle: true),
      body: FutureBuilder<List<Player>>(
        future: futurePlayers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final players = snapshot.data!;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(player.avatar),
                  ),
                  title: Text(player.username),
                  subtitle: Text(
                    "Pais: ${player.country}\nSeguidores: ${player.followers}",
                  ),
                  trailing: Icon(
                    Icons.verified,
                    color: player.verified ? Colors.blue : Colors.grey,
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
