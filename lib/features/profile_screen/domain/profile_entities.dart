class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int avatarIndex;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarIndex,
  });
}

class ProfileMovieEntity {
  final String id;
  final String title;
  final String posterUrl;
  final double rating;

  const ProfileMovieEntity({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
  });
}