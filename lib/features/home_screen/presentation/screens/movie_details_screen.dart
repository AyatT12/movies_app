import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/core/utils/app_text_styles.dart';
import 'package:movies_app/features/home_screen/data/datasources/home_remote_data_source.dart';
import 'package:movies_app/features/home_screen/domain/entities/movie_details_entity.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final HomeRemoteDataSource _dataSource = HomeRemoteDataSource();
  late Future<MovieDetailsEntity> _movieDetailsFuture;
  late Future<List<MovieSuggestionEntity>> _movieSuggestionsFuture;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = _dataSource
        .getMovieDetails(widget.movieId)
        .then((model) => model.toEntity());
    _movieSuggestionsFuture = _dataSource
        .getMovieSuggestions(widget.movieId)
        .then((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<MovieDetailsEntity>(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: AppTextStyles.errorText,
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('Movie not found', style: AppTextStyles.errorText),
            );
          }

          final movie = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      movie.mediumCoverImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 550,
                      errorBuilder: (_, __, ___) => Container(
                        height: 550,
                        width: double.infinity,
                        color: AppColors.cardDark,
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.grey,
                          size: 50,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.background.withValues(alpha: 0.3),
                              AppColors.background,
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.bookmark,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: AppColors.primary,
                            size: 70,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: Column(
                        children: [
                          Text(
                            movie.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.movieTitle,
                          ),
                          SizedBox(height: 8),
                          Text('${movie.year}', style: AppTextStyles.movieYear),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          localizations?.watch ?? 'Watch',
                          style: AppTextStyles.watchButton,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            Icons.favorite,
                            '58',
                            AppColors.primary,
                          ),
                          _buildStatItem(
                            Icons.access_time_filled,
                            '${movie.runtime}',
                            AppColors.primary,
                          ),
                          _buildStatItem(
                            Icons.star,
                            '${movie.rating}',
                            AppColors.primary,
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      Text(
                        localizations?.screenShots ?? 'Screen Shots',
                        style: AppTextStyles.sectionHeader,
                      ),
                      SizedBox(height: 16),
                      ...movie.screenshots.map(
                            (image) => Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              height: 170,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => Container(
                                height: 220,
                                width: double.infinity,
                                color: AppColors.cardDark,
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Similar',
                        style: AppTextStyles.sectionHeader,
                      ),
                      SizedBox(height: 8),
                      FutureBuilder<List<MovieSuggestionEntity>>(
                        future: _movieSuggestionsFuture,
                        builder: (context, suggestionSnapshot) {
                          if (suggestionSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (!suggestionSnapshot.hasData ||
                              suggestionSnapshot.data!.isEmpty) {
                            return SizedBox.shrink();
                          }

                          final similarMovies = suggestionSnapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: similarMovies.length > 4
                                ? 4
                                : similarMovies.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (context, index) {
                              final item = similarMovies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsScreen(
                                        movieId: item.id,
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.network(
                                          item.mediumCoverImage,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                color: AppColors.cardDark,
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.7,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${item.rating}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.star,
                                                color: AppColors.primary,
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        localizations?.summary ?? 'Summary',
                        style: AppTextStyles.sectionHeader,
                      ),
                      SizedBox(height: 12),
                      Text(
                        movie.descriptionFull.isNotEmpty
                            ? movie.descriptionFull
                            : movie.descriptionIntro,
                        style: AppTextStyles.summaryText,
                      ),
                      SizedBox(height: 32),
                      Text(
                        localizations?.cast ?? 'Cast',
                        style: AppTextStyles.sectionHeader,
                      ),
                      SizedBox(height: 16),
                      ...movie.cast.map(
                            (member) => Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.cardDark,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: member.imageUrl.isNotEmpty
                                    ? Image.network(
                                  member.imageUrl,
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 65,
                                    height: 65,
                                    color: Colors.grey,
                                    child: Icon(Icons.person),
                                  ),
                                )
                                    : Container(
                                  width: 65,
                                  height: 65,
                                  color: Colors.grey,
                                  child: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name : ${member.name}',
                                      style: AppTextStyles.castName,
                                    ),
                                    Text(
                                      'Character : ${member.characterName}',
                                      style: AppTextStyles.castCharacter,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        localizations?.genres ?? 'Genres',
                        style: AppTextStyles.sectionHeader,
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: movie.genres
                            .map(
                              (genre) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              genre,
                              style: AppTextStyles.genreText,
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(width: 10),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }
}