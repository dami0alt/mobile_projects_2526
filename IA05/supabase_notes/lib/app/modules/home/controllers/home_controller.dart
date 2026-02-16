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
  int? _cachedListenerId;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      final albumsData = await _musicRepo.getAllAlbums();
      allAlbums.assignAll(albumsData);
    } catch (e) {
      print("Error cargando álbumes: $e");
    }

    try {
      _cachedListenerId = await _musicRepo.getCurrentListenerId();

      if (_cachedListenerId != null) {
        final favs = await _musicRepo.getFavorites(_cachedListenerId!);
        userFavorites.assignAll(favs);
      }
    } catch (e) {
      print("Aviso: No se pudo cargar la info del listener ($e)");
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(String albumId) {
    return userFavorites.any((fav) => fav.idAlbum == albumId);
  }

  Future<void> toggleFavorite(String albumId) async {
    if (_cachedListenerId == null) return;
    final bool isCurrentlyFav = isFavorite(albumId);

    if (isCurrentlyFav) {
      userFavorites.removeWhere((fav) => fav.idAlbum == albumId);

      try {
        await _musicRepo.removeFavorite(_cachedListenerId!, albumId);
      } catch (e) {
        print("Error al borrar, revirtiendo cambios UI: $e");
        await loadHomeData();
      }
    } else {
      final albumToAdd = allAlbums.firstWhereOrNull((a) => a.id == albumId);

      if (albumToAdd != null) {
        // Creamos un objeto Favorite temporal
        final newFav = Favorite(
            idAlbum: albumId,
            idListener: _cachedListenerId!,
            savedAt: DateTime.now().toString(),
            album: albumToAdd);
        userFavorites.add(newFav);
        try {
          await _musicRepo.addFavorite(_cachedListenerId!, albumId);
        } catch (e) {
          userFavorites.remove(newFav);
          print("Error al guardar, revirtiendo: $e");
        }
      }
    }
    userFavorites.refresh();
  }
}
