import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/person.dart';

class PeopleSearchController extends GetxController {
  TextEditingController searchController = TextEditingController();
  var foundedPeople = <Person>[].obs;
  var isLoading = false.obs;

  void search(String query) async {
    isLoading.value = true;
    foundedPeople.value = (await ApiService.getSearchedPeople(query)) ?? [];
    isLoading.value = false;
  }
}
