import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';

class MoviesSearchController extends GetxController {
  TextEditingController searchController = TextEditingController();
  var foundedMovies = <Movie>[].obs;
  var isLoading = false.obs;

  void search(String query) async {
    isLoading.value = true;
    foundedMovies.value = (await ApiService.getSearchedMovies(query)) ?? [];
    isLoading.value = false;
  }
}
