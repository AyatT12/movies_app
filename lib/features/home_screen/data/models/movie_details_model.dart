import '../../domain/entities/movie_details_entity.dart';

class MovieCastModel {
  final String name;
  final String characterName;
  final String imageUrl;

  const MovieCastModel({
    required this.name,
    required this.characterName,
    required this.imageUrl,
  });

  factory MovieCastModel.fromJson(Map<String, dynamic> json) {
    return MovieCastModel(
      name: json['name']?.toString() ?? '',
      characterName: json['character_name']?.toString() ?? '',
      imageUrl: json['url_small_image']?.toString() ?? '',
    );
  }

  MovieCastEntity toEntity() {
    return MovieCastEntity(
      name: name,
      characterName: characterName,
      imageUrl: imageUrl,
    );
  }
}

class MovieDetailsModel {
  final int id;
  final String title;
  final num rating;
  final String descriptionIntro;
  final String descriptionFull;
  final String backgroundImage;
  final String mediumCoverImage;
  final int year;
  final int runtime;
  final List<String> genres;
  final List<String> screenshots;
  final List<MovieCastModel> cast;

  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.descriptionIntro,
    required this.descriptionFull,
    required this.backgroundImage,
    required this.mediumCoverImage,
    required this.year,
    required this.runtime,
    required this.genres,
    required this.screenshots,
    required this.cast,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final screenshots = <String>[];
    for (var i = 1; i <= 3; i++) {
      final imageKey = 'medium_screenshot_image$i';
      final image = json[imageKey]?.toString();
      if (image != null && image.isNotEmpty) {
        screenshots.add(image);
      }
    }

    final castList = (json['cast'] as List<dynamic>? ?? [])
        .map((item) => MovieCastModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return MovieDetailsModel(
      id: json['id'] ?? 0,
      title:
          json['title']?.toString() ?? json['title_english']?.toString() ?? '',
      rating: json['rating'] ?? 0.0,
      descriptionIntro: json['description_intro']?.toString() ?? '',
      descriptionFull: json['description_full']?.toString() ?? '',
      backgroundImage: json['background_image']?.toString() ?? '',
      mediumCoverImage:
          json['large_cover_image']?.toString() ??
          json['medium_cover_image']?.toString() ??
          '',
      year: json['year'] ?? DateTime.now().year,
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      screenshots: screenshots,
      cast: castList,
    );
  }

  MovieDetailsEntity toEntity() {
    return MovieDetailsEntity(
      id: id,
      title: title,
      rating: rating,
      descriptionIntro: descriptionIntro,
      descriptionFull: descriptionFull,
      backgroundImage: backgroundImage,
      mediumCoverImage: mediumCoverImage,
      year: year,
      runtime: runtime,
      genres: genres,
      screenshots: screenshots,
      cast: cast.map((item) => item.toEntity()).toList(),
    );
  }
}
