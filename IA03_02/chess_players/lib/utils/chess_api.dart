import 'dart:convert';
import 'dart:io';
import '../entities/player.dart';

class ApiService {
  static final HttpClient _httpClient = HttpClient();

  // 🔄 Cambiamos el nombre del método y ahora recibe explícitamente la lista de usernames.
  // Es mejor usar Future.wait para eficiencia, ¡pero mantendremos el bucle junior!
  static Future<List<Player>> fetchPlayersByUsername(
    List<String> usernames,
  ) async {
    List<Player> players = [];

    // 💡 La URL de detalle es la única que necesitamos: 'https://api.chess.com/pub/player/$username'

    // --- 1. Obtener los detalles de cada jugador individualmente ---
    for (final username in usernames) {
      try {
        final detailRequest = await _httpClient.getUrl(
          Uri.parse('https://api.chess.com/pub/player/$username'),
        );
        final detailResponse = await detailRequest.close();

        if (detailResponse.statusCode == HttpStatus.ok) {
          final detailResponseBody = await detailResponse
              .transform(utf8.decoder)
              .join();
          final Map<String, dynamic> playerData = jsonDecode(
            detailResponseBody,
          );

          // 🧠 Uso directo de la fábrica Player.fromJson.
          players.add(Player.fromJson(playerData));
        } else {
          print(
            'Error fetching details for $username: ${detailResponse.statusCode}',
          );
          // Continúa con el siguiente jugador si este falla.
        }
      } catch (e) {
        print('Exception during player detail fetch for $username: $e');
        // Continúa con el siguiente jugador si este falla.
      }
    }

    _httpClient.close();
    print("$usernames catched");
    return players;
  }
}
