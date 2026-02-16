class Album {
  String id;
  String title;
  String artist;
  String? photoUrl;
  String createdAt;

  Album(
      {required this.id,
      required this.title,
      required this.artist,
      this.photoUrl,
      required this.createdAt});

  Album.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        title = json['title'] ?? "Unknown",
        artist = json['artist'] ?? "Unknown",
        photoUrl = json['photo_url'] ?? "",
        createdAt = json['created_at'] ?? "Unknown";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'photo_url': photoUrl,
      'created_at': createdAt,
    };
  }

  static List<Album> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Album.fromJson(e)).toList();
  }
}
