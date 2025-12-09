import 'dart:convert';
import 'package:http/http.dart' as http;

class Player {
  final String avatar;
  final int playerId;
  final String id;
  final String url;
  String name;
  String username;
  int followers;
  final String country;
  final int lastOnline;
  final int joined;
  String status;
  final bool isStreamer;
  final bool verified;
  String league;
  final List<String> streamingPlatforms;
  //optionals properties
  bool isFavorite;
  String? notes;
  double rating;

  Player({
    required this.avatar,
    required this.playerId,
    required this.id,
    required this.url,
    required this.name,
    required this.username,
    required this.followers,
    required this.country,
    required this.lastOnline,
    required this.joined,
    required this.status,
    required this.isStreamer,
    required this.verified,
    required this.league,
    required this.streamingPlatforms,
    this.isFavorite = false,
    this.rating = 2.5,
  });
  factory Player.fromJson(Map<String, dynamic> json) {
    List<String> platforms = [];

    return Player(
      avatar:
          json['avatar'] ??
          'https://static.vecteezy.com/system/resources/previews/004/511/281/original/default-avatar-photo-placeholder-profile-picture-vector.jpg',
      playerId: json['player_id'] ?? 0,
      name: json['name'] ?? 'N/A',
      id: json['@id'] ?? '',
      url: json['url'] ?? '',
      username: json['username'] ?? '',
      followers: json['followers'] ?? 0,
      country: json['country'] ?? '',
      lastOnline: json['last_online'] ?? 0,
      joined: json['joined'] ?? 0,
      status: json['status'] ?? '',
      isStreamer: json['is_streamer'] ?? false,
      verified: json['verified'] ?? false,
      league: json['league'] ?? '',
      streamingPlatforms: platforms,
    );
  }
}

class PlayersApiService {
  static Future<List<Player>> getPlayer(List<String> playersUsername) async {
    final List<Player> list = [];

    for (var username in playersUsername) {
      final response = await http.get(
        Uri.parse("https://api.chess.com/pub/player/$username"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        list.add(Player.fromJson(data));
      } else {
        throw Exception('HTTP Failed: ${response.statusCode}');
      }
    }
    return list;
  }
}
