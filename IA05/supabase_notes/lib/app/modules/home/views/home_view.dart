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
                "Descubre Álbumes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // 1. EL CARRUSEL
            _buildCarousel(),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                "Tus Favoritos",
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
      return const Center(child: Text("No hay álbumes disponibles"));
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
    if (controller.userFavorites.isEmpty) {
      return const Center(child: Text("Aún no tienes favoritos"));
    }

    return ListView.builder(
      itemCount: controller.userFavorites.length,
      itemBuilder: (context, index) {
        final Favorite fav = controller.userFavorites[index];
        // Protección: Si el álbum vino nulo de la DB, no renderizamos error
        if (fav.album == null) return const SizedBox.shrink();

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: fav.album!.photoUrl != null
                ? NetworkImage(fav.album!.photoUrl!)
                : null,
            child: fav.album!.photoUrl == null
                ? const Icon(Icons.music_note)
                : null,
          ),
          title: Text(fav.album!.title),
          subtitle: Text(fav.album!.artist),
          trailing: const Icon(Icons.favorite, color: Colors.red),
        );
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
                  color: isFav ? Colors.red : Colors.white,
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
