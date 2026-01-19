import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:get/get.dart';

enum AppModule { movies, actors, series }

class AppModuleController extends GetxController {
  // Start with "Actors"
  var selectedModule = AppModule.actors.obs;

  void changeModule(AppModule module) {
    selectedModule.value = module;
    // Allways when category changes, the Navigator index will be reset to home screen.
    Get.find<BottomNavigatorController>().setIndex(0);
  }
}
