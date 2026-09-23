class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int avatarIndex;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarIndex,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarIndex: json['avatarId'] ?? json['avatarIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'avatarId': avatarIndex,
    };
  }
}

class ProfileMovieModel {
  final String id;
  final String title;
  final String posterUrl;
  final double rating;

  ProfileMovieModel({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
  });

  factory ProfileMovieModel.fromJson(Map<String, dynamic> json) {
    return ProfileMovieModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      posterUrl: json['poster_path'] ?? json['posterUrl'] ?? json['image'] ?? '',
      rating: (json['vote_average'] ?? json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'rating': rating,
    };
  }
}