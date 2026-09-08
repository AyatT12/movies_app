class MovieModel {
  final int id;
  final String title;
  final num rating;
  final String mediumCoverImage;
  final List<String> genres;

  const MovieModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.mediumCoverImage,
    required this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      rating: json['rating'] ?? 0.0,
      mediumCoverImage: json['medium_cover_image'] ?? '',
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}