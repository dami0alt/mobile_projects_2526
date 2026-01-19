import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:movies/screens/people_home_screen.dart';
import 'package:movies/screens/people_search_screen.dart';
import 'package:movies/screens/favorite_list_screen.dart';
import 'package:movies/screens/movies_home_screen.dart';
import 'package:movies/screens/movies_search_screen.dart';
import 'package:movies/screens/watch_list_screen.dart';

class BottomNavigatorController extends GetxController {
  var index = 0.obs;

  // Screens for the actor module.
  List<Widget> actorScreens = [
    PeopleHomeScreen(),
    PeopleSearchScreen(),
    FavoriteList(),
  ];

  // Screens for the movies module.
  List<Widget> movieScreens = [
    MoviesHomeScreen(),
    MoviesSearchScreen(),
    MoviesWatchList(),
  ];

  void setIndex(i) => index.value = i;
}
