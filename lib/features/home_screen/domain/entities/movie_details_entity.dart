class MovieCastEntity {
  final String name;
  final String characterName;
  final String imageUrl;

  const MovieCastEntity({
    required this.name,
    required this.characterName,
    required this.imageUrl,
  });
}

class MovieDetailsEntity {
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
  final List<MovieCastEntity> cast;

  const MovieDetailsEntity({
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
}

class MovieSuggestionEntity {
  final int id;
  final String title;
  final double rating;
  final String mediumCoverImage;

  const MovieSuggestionEntity({
    required this.id,
    required this.title,
    required this.rating,
    required this.mediumCoverImage,
  });
}