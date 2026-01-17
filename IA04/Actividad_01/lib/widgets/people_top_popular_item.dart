import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';

import 'package:movies/models/person.dart';
import 'package:movies/controllers/people_controller.dart';
import 'package:movies/screens/person_details_screen.dart';
import 'package:movies/widgets/index_number.dart';

class PeopleTopRatedItem extends StatelessWidget {
  const PeopleTopRatedItem({
    super.key,
    required this.person,
    required this.index,
  });

  final Person person;
  final int index;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PeopleController>();
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            controller.loadPersonDetails(person); // Triggers extra data upload
            Get.to(() => DetailsScreenPerson());
          },
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                Api.imageBaseUrl + person.profilePath,
                fit: BoxFit.cover,
                height: 250,
                width: 180,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  size: 180,
                ),
                loadingBuilder: (_, __, ___) {
                  // ignore: no_wildcard_variable_uses
                  if (___ == null) return __;
                  return const FadeShimmer(
                    width: 180,
                    height: 250,
                    highlightColor: Color(0xff22272f),
                    baseColor: Color(0xff20252d),
                  );
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: IndexNumber(number: index),
        )
      ],
    );
  }
}
