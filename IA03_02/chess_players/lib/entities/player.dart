class Player {
  final String avatar; // URL de la imagen
  final int playerId; // Identificador numérico
  final String id; // @id del API
  final String url; // Perfil público
  final String name; // Nombre completo
  final String username; // Nombre de usuario
  final int followers; // Número de seguidores
  final String country; // URL del país
  final int lastOnline; // Timestamp (segundos desde epoch)
  final int joined; // Timestamp (segundos desde epoch)
  final String status; // Estado (basic, premium, etc.)
  final bool isStreamer; // Si es streamer
  final bool verified; // Si está verificado
  final String league; // Liga actual
  final List<String> streamingPlatforms;
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
  });
  factory Player.fromJson(Map<String, dynamic> json) {
    // Manejo del campo 'streaming_platforms' (el más problemático)
    List<String> platforms = [];
    final rawPlatforms = json['streaming_platforms'];

    if (rawPlatforms is List) {
      // 💡 Un junior haría un mapeo simple si se sabe que contiene URLs/Strings.
      // Como contiene Mapas, lo simplificaremos a un listado vacío o extraeremos las URLs.
      platforms = rawPlatforms
          .where((item) => item is Map && item.containsKey('channel_url'))
          .map((item) => item['channel_url'] as String)
          .toList();
    }

    return Player(
      // 1. Manejando campos que pueden ser nulos o faltar (usando ?? '')
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? 'N/A', // Magnus no tenía nombre, usamos 'N/A'
      // El campo '@id' se llama simplemente 'id' en tu clase
      id: json['@id'] ?? '',

      // 2. Otros campos
      playerId: json['player_id'] ?? 0,
      url: json['url'] ?? '',
      username: json['username'] ?? '',
      followers: json['followers'] ?? 0,
      country: json['country'] ?? '',
      lastOnline: json['last_online'] ?? 0,
      joined: json['joined'] ?? 0,
      status: json['status'] ?? '',
      isStreamer: json['is_streamer'] ?? false,
      verified: json['verified'] ?? false,

      // El campo 'league' puede faltar
      league: json['league'] ?? '',

      // 3. Usando la lista 'platforms' que hemos parseado
      streamingPlatforms: platforms,
    );
  }
}

class CustomPlayerData {
  String? alias;
  String? notes;
  bool isFavorite;

  CustomPlayerData({this.alias, this.notes, this.isFavorite = false});
}
