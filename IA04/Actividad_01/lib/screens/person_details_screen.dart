import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';

import 'package:movies/controllers/people_controller.dart';
import 'package:movies/models/person.dart';

class DetailsScreenPerson extends StatelessWidget {
  const DetailsScreenPerson({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PeopleController peopleController = Get.find<PeopleController>();
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final p = peopleController.selectedPerson.value;

          return SingleChildScrollView(
            child: Column(
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                      const Text('Detail', style: TextStyle(fontSize: 24)),
                      IconButton(
                        onPressed: () => peopleController.addToFavoriteList(p),
                        icon: Icon(
                          peopleController.isInFavoriteList(p)
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- STACK DE IMÁGENES ---
                SizedBox(
                  height: 330,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          Api.imageBaseUrl + p.profilePath,
                          width: Get.width,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500/${p.profilePath}',
                              width: 110,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 255,
                        left: 155,
                        child: Text(
                          p.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                _buildInfoBar(p),
                Material(
                  color: Colors.transparent,
                  child: _buildTabs(p),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoBar(Person p) {
    return Opacity(
      opacity: .6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/calender.svg'),
          const SizedBox(width: 5),
          Text(p.birthday ?? "..."),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10), child: Text('|')),
          SvgPicture.asset('assets/Ticket.svg'),
          const SizedBox(width: 5),
          Text(p.placeOfBirth ?? "..."),
        ],
      ),
    );
  }

  Widget _buildTabs(Person p) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Color(0xFF3A3F47),
              tabs: [
                Tab(text: 'About Actor'),
                Tab(text: 'Movies/Series Participation'),
              ],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      p.biography ?? "Cargando biografía...",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const Center(child: Text("Sección de Reseñas")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
