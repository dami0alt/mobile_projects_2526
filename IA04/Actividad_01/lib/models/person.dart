import 'dart:convert';

class Person {
  final int id;
  final String name;
  final String profilePath;
  final double popularity;
  final String? biography;
  final String? birthday;
  final String? placeOfBirth;
  Person({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.popularity,
    this.biography,
    this.birthday,
    this.placeOfBirth,
  });

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'] as int,
      name: map['name'] ?? '',
      profilePath: map['profile_path'] ?? '',
      popularity: (map['popularity'] ?? 0.0).toDouble(),
      biography: map['biography'] ?? '',
      birthday: map['birthday'] ?? '',
      placeOfBirth: map['place_of_birth'] ?? '',
    );
  }
  factory Person.fromJson(String source) => Person.fromMap(jsonDecode(source));
}
