import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/app_module_controller.dart';

class Main extends StatelessWidget {
  Main({super.key});

  final BottomNavigatorController navLinesController =
      Get.put(BottomNavigatorController());
  final AppModuleController moduleController = Get.put(AppModuleController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          drawer: _buildDrawer(moduleController),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF242A32),
            title: Text(
              moduleController.selectedModule.value == AppModule.actors
                  ? "Actors"
                  : "Movies",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          // --------------------------
          body: SafeArea(
            child: IndexedStack(
              index: navLinesController.index.value,
              // Aquí llamamos a una función que devuelva las pantallas según el módulo
              children:
                  _getScreensForModule(moduleController.selectedModule.value),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(navLinesController),
        ),
      ),
    );
  }

  // Lógica para decidir qué set de pantallas mostrar en el Bottom Bar
  List<Widget> _getScreensForModule(AppModule module) {
    if (module == AppModule.actors) {
      return navLinesController.actorScreens; // Las que ya tienes
    } else {
      return navLinesController.movieScreens; // Las originales de pelis
    }
  }

  Widget _buildDrawer(AppModuleController controller) {
    return Drawer(
      backgroundColor: const Color(0xFF242A32),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0296E5)),
            child: Text("TMDB ",
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text("Actors", style: TextStyle(color: Colors.white)),
            onTap: () => controller.changeModule(AppModule.actors),
          ),
          ListTile(
            leading: const Icon(Icons.movie, color: Colors.white),
            title: const Text("Movies", style: TextStyle(color: Colors.white)),
            onTap: () => controller.changeModule(AppModule.movies),
          ),
        ],
      ),
    );
  }

  // Moví tu BottomBar a un método para limpiar el build
  Widget _buildBottomBar(BottomNavigatorController controller) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF0296E5), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: controller.index.value,
        onTap: (index) => controller.setIndex(index),
        backgroundColor: const Color(0xFF242A32),
        selectedItemColor: const Color(0xFF0296E5),
        unselectedItemColor: const Color(0xFF67686D),
        items: [
          _navItem('assets/Home.svg', 'Home', controller.index.value == 0),
          _navItem('assets/Search.svg', 'Search', controller.index.value == 1),
          _navItem('assets/Save.svg', 'Favorites', controller.index.value == 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      String asset, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        asset,
        height: 21,
        color: isSelected ? const Color(0xFF0296E5) : const Color(0xFF67686D),
      ),
      label: label,
    );
  }
}
