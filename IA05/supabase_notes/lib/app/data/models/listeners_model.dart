class Listener {
  int id;
  int userId;
  String firstName;
  String lastName;
  String email;
  String? photoUrl;
  String createdAt;

  Listener(
      {required this.id,
      required this.userId,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.photoUrl,
      required this.createdAt});

  Listener.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? "",
        userId = json['uid'] ?? "",
        firstName = json['fname'] ?? "Unknown",
        lastName = json['lname'] ?? "Unknown",
        email = json['email'] ?? "",
        photoUrl = json['photo_url'] ?? "",
        createdAt = json['created_at'] ?? "Unknown";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': userId,
      'fname': firstName,
      'lname': lastName,
      'email': email,
      'photo_url': photoUrl,
      'created_at': createdAt,
    };
  }

  static List<Listener> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Listener.fromJson(e)).toList();
  }
}
