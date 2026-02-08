import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/albums_model.dart';
import 'package:supabase_notes/app/data/models/favorites_model.dart';
import 'package:supabase_notes/app/data/repositories/music_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  final MusicRepository _musicRepo = MusicRepository();

  final RxList<Album> allAlbums = List<Album>.empty().obs;
  final RxList<Favorite> userFavorites = List<Favorite>.empty().obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      final String currentListenerId = await _musicRepo.getCurrentListenerId();

      // 2. El controlador solo PEDIENTE datos
      final albumsData = await _musicRepo.getAllAlbums();
      final favsData = await _musicRepo.getFavorites(currentListenerId);

      // 3. Actualizamos estado
      allAlbums.assignAll(albumsData);
      userFavorites.assignAll(favsData);
    } catch (e) {
      print("Error loading home: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(String albumId) {
    return userFavorites.any((fav) => fav.idAlbum == albumId);
  }

  Future<void> toggleFavorite(String albumId) async {
    print("Toggle favorite para album: $albumId");
  }
}
