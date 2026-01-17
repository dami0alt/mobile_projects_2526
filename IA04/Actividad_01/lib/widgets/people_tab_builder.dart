import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/models/person.dart';
import 'package:movies/screens/person_details_screen.dart';
import 'package:movies/controllers/people_controller.dart';

class PeopleTabBuilder extends StatelessWidget {
  const PeopleTabBuilder({
    required this.future,
    super.key,
  });
  final Future<List<Person>?> future;

  @override
  Widget build(BuildContext context) {
    // Search the controller to manage the navigation details.
    final peopleController = Get.find<PeopleController>();

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12.0),
      child: FutureBuilder<List<Person>?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.6,
              ),
              //The limite is 6 items
              itemCount: snapshot.data!.length > 6 ? 6 : snapshot.data!.length,
              itemBuilder: (context, index) {
                final personItem = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    // 1. Loading extra data during the navigation
                    peopleController.loadPersonDetails(personItem);
                    // 2. Navegation to Details Scre
                    Get.to(() => DetailsScreenPerson());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/${personItem.profilePath}',
                      height: 300,
                      width: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const FadeShimmer(
                          width: 180,
                          height: 250,
                          highlightColor: Color(0xff22272f),
                          baseColor: Color(0xff20252d),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
