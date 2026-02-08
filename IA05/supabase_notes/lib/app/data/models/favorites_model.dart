import 'package:supabase_notes/app/data/models/albums_model.dart';

class Favorite {
  String idAlbum;
  int idListener;
  String? savedAt;
  Album? album;

  Favorite(
      {required this.idAlbum,
      required this.idListener,
      required this.savedAt,
      this.album});

  Favorite.fromJson(Map<String, dynamic> json)
      : idAlbum = json['album_id'] ?? "",
        idListener = json['listener_id'] ?? "Unknown",
        savedAt = json['saved_at'] ?? "Unknown",
        album = json['albums'] != null ? Album.fromJson(json['albums']) : null;

  Map<String, dynamic> toJson() {
    return {
      'album_id': idAlbum,
      'listener_id': idListener,
      'saved_at': savedAt,
    };
  }

  static List<Favorite> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Favorite.fromJson(e)).toList();
  }
}
