import 'package:get/get.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:movies/screens/people_search_screen.dart';
import 'package:movies/screens/favorite_list_screen.dart';

class BottomNavigatorController extends GetxController {
  var screens = [
    HomeScreen(),
    const PeopleSearchScreen(),
    const FavoriteList(),
  ];
  var index = 0.obs;
  void setIndex(indx) => index.value = indx;
}
