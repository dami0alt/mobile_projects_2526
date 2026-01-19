import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/movies_search_controller.dart'; // Importa el de pelis
import 'package:movies/widgets/search_box.dart';
// Asegúrate de usar los builders y items de PELÍCULAS
import 'package:movies/widgets/tab_builder.dart';
import 'package:movies/widgets/top_rated_item.dart';

class MoviesHomeScreen extends StatelessWidget {
  MoviesHomeScreen({super.key});

  // Solo necesitamos los controladores relacionados con películas
  final MoviesController mcontroller = Get.put(MoviesController());
  final MoviesSearchController mSearchController =
      Get.put(MoviesSearchController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What do you want to watch?', // Mensaje adaptado
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            // BUSCADOR DE PELÍCULAS
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<MoviesSearchController>().searchController.text;
                Get.find<MoviesSearchController>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 34),
            // CARRUSEEL DE PELÍCULAS TOP RATED
            Obx(
              (() => mcontroller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 300,
                      child: Center(
                        child: ListView.separated(
                          itemCount: mcontroller.mainTopRatedMovies.length,
                          scrollDirection: Axis.horizontal,
                          // Importante: shrinkWrap permite que el ListView solo ocupe el ancho necesario
                          shrinkWrap: true,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 24),
                          itemBuilder: (_, index) => TopRatedItem(
                              movie: mcontroller.mainTopRatedMovies[index],
                              index: index + 1),
                        ),
                      ),
                    )),
            ),
            // TABS DE CATEGORÍAS DE PELÍCULAS
            DefaultTabController(
              length: 4, // Las películas suelen tener más categorías
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: TabBar(
                      isScrollable: true,
                      indicatorWeight: 3,
                      indicatorColor: Color(0xFF3A3F47),
                      labelStyle: TextStyle(fontSize: 11.0),
                      tabs: [
                        Tab(text: 'Now Playing'),
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Top Rated'),
                        Tab(text: 'Popular'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(children: [
                      TabBuilder(
                        // Builder de pelis
                        future: ApiService.getCustomMovies(
                            'now_playing?api_key=${Api.apiKey}'),
                      ),
                      TabBuilder(
                        future: ApiService.getCustomMovies(
                            'upcoming?api_key=${Api.apiKey}'),
                      ),
                      TabBuilder(
                        future: ApiService.getCustomMovies(
                            'top_rated?api_key=${Api.apiKey}'),
                      ),
                      TabBuilder(
                        future: ApiService.getCustomMovies(
                            'popular?api_key=${Api.apiKey}'),
                      ),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
