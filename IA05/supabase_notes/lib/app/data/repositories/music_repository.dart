import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/albums_model.dart';
import '../models/favorites_model.dart';

class MusicRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> getCurrentListenerId() async {
    final user = _client.auth.currentUser;

    if (user == null) throw Exception("no users logged-in");
    try {
      final response = await _client
          .from('listeners')
          .select('id')
          .eq('uid', user.id!)
          .single();
      return response['id'].toString();
    } catch (e) {
      throw Exception("Colud not found any result: $e");
    }
  }

  Future<List<Album>> getAllAlbums() async {
    List<Album> albums = [];
    final res = await _client.from("albums").select("*");

    if (res.isEmpty) {
      throw Exception("No response from request server");
    }
    albums = Album.fromJsonList((res as List));
    return albums;
  }

  Future<List<Favorite>> getFavorites(String listenerId) async {
    List<Favorite> favorites = [];
    try {
      final response = await _client
          .from('favorites')
          .select('*, albums(*)')
          .eq('listener_id', listenerId);

      favorites = Favorite.fromJsonList(response as List);
      return favorites;
    } catch (e) {
      print("Error en repo: $e");
      return [];
    }
  }
}
