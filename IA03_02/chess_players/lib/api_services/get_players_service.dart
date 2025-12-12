import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chess_players/entities/player.dart';

class PlayersApiService {
  static Future<Player> fetchSinglePlayer(String username) async {
    final response = await http.get(
      Uri.parse("https://api.chess.com/pub/player/$username"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Player.fromJson(data);
    } else {
      throw Exception(
        'Player $username not found. HTTP Status: ${response.statusCode}',
      );
    }
  }

  static Future<List<Player>> fetchPlayers(List<String> playersUsername) async {
    final List<Future<Player>> fetchFutures = playersUsername.map((username) {
      return fetchSinglePlayer(username);
    }).toList();
    try {
      final List<Player> players = await Future.wait(fetchFutures);
      return players;
    } catch (e) {
      rethrow;
    }
  }
}
