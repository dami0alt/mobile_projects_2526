import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/albums_model.dart';
import '../models/favorites_model.dart';

class MusicRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<int> getCurrentListenerId() async {
    final user = _client.auth.currentUser;

    if (user == null) throw Exception("no users logged-in");
    try {
      final response = await _client
          .from('listeners')
          .select('id')
          .eq('email', user.email!)
          .single();
      return response['id'] as int;
    } catch (e) {
      throw Exception("Colud not find any result: $e");
    }
  }

  Future<List<Album>> getAllAlbums() async {
    try {
      final res = await _client.from("albums").select("*");
      if (res.isEmpty) return [];
      return Album.fromJsonList(res as List);
    } catch (e) {
      print("Error fetching albums: $e");
      return [];
    }
  }

  Future<List<Favorite>> getFavorites(int listenerId) async {
    try {
      final response = await _client
          .from('favorites')
          .select('*, albums(*)')
          .eq('listener_id', listenerId);

      return Favorite.fromJsonList(response as List);
    } catch (e) {
      print("Error en repo favorites: $e");
      return [];
    }
  }

  Future<void> addFavorite(int listenerId, String albumId) async {
    try {
      await _client.from('favorites').insert({
        'listener_id': listenerId,
        'album_id': albumId,
        'saved_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception("Error añadiendo favorito: $e");
    }
  }

  Future<void> removeFavorite(int listenerId, String albumId) async {
    try {
      await _client.from('favorites').delete().match({
        'listener_id': listenerId,
        'album_id': albumId,
      });
    } catch (e) {
      throw Exception("Error eliminando favorito: $e");
    }
  }
}
