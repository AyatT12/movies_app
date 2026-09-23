class MovieItemModel {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;

  MovieItemModel({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
  });

  factory MovieItemModel.fromJson(Map<String, dynamic> json) {
    return MovieItemModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterUrl: json['medium_cover_image'] ?? json['poster'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'medium_cover_image': posterUrl,
      'rating': rating,
    };
  }
}