import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/data/models/favorites_model.dart';
import 'package:supabase_notes/app/data/models/albums_model.dart';
import 'package:supabase_notes/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MUSIC HUB'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.PROFILE);
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Discover Albums",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // 1. EL CARRUSEL
            _buildCarousel(),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                "Your favorites",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // 2. LA LISTA DE FAVORITOS
            Expanded(child: _buildFavoritesList()),
          ],
        );
      }),
    );
  }

  // Widget del Carrusel (PageView)
  Widget _buildCarousel() {
    if (controller.allAlbums.isEmpty) {
      return const Center(child: Text("There are not albumes avaible"));
    }

    return SizedBox(
      height: 250, // Altura fija para el carrusel
      child: PageView.builder(
        controller:
            PageController(viewportFraction: 0.8), // Efecto de ver el siguiente
        itemCount: controller.allAlbums.length,
        itemBuilder: (context, index) {
          final Album album = controller.allAlbums[index];
          return _AlbumCard(album: album, controller: controller);
        },
      ),
    );
  }

  Widget _buildFavoritesList() {
    // Protección contra lista vacía
    if (controller.userFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.grey[800]),
            const SizedBox(height: 10),
            const Text("Your collection is empty",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(), // Scroll suave tipo iOS/Spotify
      padding: const EdgeInsets.symmetric(vertical: 10), // Un poco de aire
      itemCount: controller.userFavorites.length,
      itemBuilder: (context, index) {
        final Favorite fav = controller.userFavorites[index];

        // 1. Validación de seguridad
        if (fav.album == null) return const SizedBox.shrink();

        final album =
            fav.album!; // Creamos el alias 'album' para escribir menos

        // 2. Usamos Obx AQUÍ para que cada fila sea inteligente
        return Obx(() {
          // Calculamos el estado real
          final isFav = controller.isFavorite(album.id);

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), // Borde sutil
                image: album.photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(album.photoUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey[800], // Placeholder color
              ),
              child: album.photoUrl == null
                  ? const Icon(Icons.music_note, color: Colors.white)
                  : null,
            ),

            // Títulos blancos y subtítulos grises (definidos en tu Theme, pero forzamos por seguridad)
            title: Text(
              album.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white),
            ),
            subtitle: Text(
              album.artist,
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),

            // 4. Botón de Acción
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                // Usamos el VERDE de tu tema (primaryColor) o Rojo si prefieres
                color: isFav ? const Color(0xFF1DB954) : Colors.white,
                size: 26,
              ),
              onPressed: () {
                // Ahora sí usamos la variable 'album' correcta
                controller.toggleFavorite(album.id);
              },
            ),
          );
        });
      },
    );
  }
}

// Widget extraído para la tarjeta del carrusel (Mejor rendimiento)
class _AlbumCard extends StatelessWidget {
  final Album album;
  final HomeController controller;

  const _AlbumCard({required this.album, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Obx local: Solo redibuja el icono del corazón si cambia, no toda la tarjeta
    return Obx(() {
      final isFav = controller.isFavorite(album.id);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Placeholder color
          borderRadius: BorderRadius.circular(20),
          image: album.photoUrl != null && album.photoUrl!.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(album.photoUrl!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),
                      BlendMode.darken), // Oscurecer un poco para leer texto
                )
              : null,
        ),
        child: Stack(
          children: [
            // Texto del Album
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    album.artist,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Botón de Favorito
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Color(0xFF1DB954) : Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  controller.toggleFavorite(album.id);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
