import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/people_controller.dart';
import 'package:movies/controllers/people_search_controller.dart';
import 'package:movies/widgets/search_box.dart';
import 'package:movies/widgets/people_tab_builder.dart';
import 'package:movies/widgets/people_top_popular_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PeopleController pcontroller = Get.put(PeopleController());
  final PeopleSearchController searchController =
      Get.put(PeopleSearchController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Who do you want to known?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<PeopleSearchController>().searchController.text;
                Get.find<PeopleSearchController>().searchController.text = '';
                Get.find<PeopleSearchController>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(
              height: 34,
            ),
            Obx(
              (() => pcontroller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: pcontroller.mainTopRatedPeople.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) => PeopleTopRatedItem(
                            person: pcontroller.mainTopRatedPeople[index],
                            index: index + 1),
                      ),
                    )),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                      indicatorWeight: 3,
                      indicatorColor: Color(
                        0xFF3A3F47,
                      ),
                      labelStyle: TextStyle(fontSize: 11.0),
                      tabs: [
                        Tab(text: 'Populars'),
                        Tab(text: 'Trending Weekly'),
                      ]),
                  SizedBox(
                    height: 400,
                    child: TabBarView(children: [
                      PeopleTabBuilder(
                        future: ApiService.getCustomPeople(
                            'person/popular?api_key=${Api.apiKey}&language=en-US&page=1'),
                      ),
                      PeopleTabBuilder(
                        future: ApiService.getCustomPeople(
                            'trending/person/week?api_key=${Api.apiKey}&language=en-US&page=1'),
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
