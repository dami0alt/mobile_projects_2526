import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/person.dart';
import 'package:movies/models/movie.dart';

//Controller for state management by the actors (People)
//Use Getx to drive reactivity on people list and actors details
class PeopleController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedPeople = <Person>[].obs;
  var favoriteListPeople = <Person>[].obs;

  var personMovies = <Movie>[].obs;

  var selectedPerson =
      Person(id: 0, name: '', profilePath: '', popularity: 0).obs;
  //
  @override
  void onInit() async {
    isLoading.value = true;
    mainTopRatedPeople.value = (await ApiService.getTopRatedActors())!;
    isLoading.value = false;
    super.onInit();
  }

//Check if the person is into favorite list people
  bool isInFavoriteList(Person person) {
    return favoriteListPeople.any((p) => p.id == person.id);
  }

  void addToFavoriteList(Person person) {
    if (isInFavoriteList(person)) {
      favoriteListPeople.removeWhere((p) => p.id == person.id);
      Get.snackbar('Success', 'removed from favorite list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500),
          backgroundColor: Color.fromARGB(255, 255, 255, 255));
    } else {
      favoriteListPeople.add(person);
      Get.snackbar('Success', 'added to favorite list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500),
          backgroundColor: Color.fromARGB(255, 255, 255, 255));
    }
  }

  // loadPersonDetails Updated
  Future<void> loadPersonDetails(Person person) async {
    isLoading.value = true;
    selectedPerson.value = person;
    personMovies.clear(); // Clear Actor's movies before

    // Parallel call to improve performance
    var results = await Future.wait([
      ApiService.getInfoPerson(person.id),
      ApiService.getPersonMovieCredits(person.id),
    ]);

    if (results[0] != null) selectedPerson.value = results[0] as Person;
    if (results[1] != null) personMovies.value = results[1] as List<Movie>;

    isLoading.value = false;
  }
}
