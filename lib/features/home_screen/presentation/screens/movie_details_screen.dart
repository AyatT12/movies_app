import 'package:flutter/material.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/core/utils/app_text_styles.dart';
import 'package:movies_app/features/home_screen/data/datasources/home_remote_data_source.dart';
import 'package:movies_app/features/home_screen/domain/entities/movie_details_entity.dart';

import 'package:movies_app/l10n/app_localizations.dart';

import '../../../profile_screen/domain/profile_entities.dart';
import '../../../profile_screen/domain/profile_repo.dart';

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
  bool _isInWatchList = false;

  @override
  void initState() {
    super.initState();
    _checkWatchListStatus();
    _movieDetailsFuture = _dataSource
        .getMovieDetails(widget.movieId)
        .then((model) {
      final entity = model.toEntity();
      _recordHistory(entity);
      return entity;
    });
    _movieSuggestionsFuture = _dataSource
        .getMovieSuggestions(widget.movieId)
        .then((models) => models.map((m) => m.toEntity()).toList());
  }

  Future<void> _checkWatchListStatus() async {
    try {
      final isSaved = await sl<ProfileRepo>().isMovieInWatchList(widget.movieId.toString());
      if (mounted) {
        setState(() {
          _isInWatchList = isSaved;
        });
      }
    } catch (_) {}
  }

  void _recordHistory(MovieDetailsEntity movie) {
    sl<ProfileRepo>().addToHistory(
      ProfileMovieEntity(
        id: movie.id.toString(),
        title: movie.title,
        posterUrl: movie.mediumCoverImage,
        rating: movie.rating.toDouble(),
      ),
    );
  }

  Future<void> _toggleWatchList(MovieDetailsEntity movie) async {
    try {
      final movieEntity = ProfileMovieEntity(
        id: movie.id.toString(),
        title: movie.title,
        posterUrl: movie.mediumCoverImage,
        rating: movie.rating.toDouble(),
      );
      await sl<ProfileRepo>().toggleWatchList(movieEntity);
      if (mounted) {
        setState(() {
          _isInWatchList = !_isInWatchList;
        });
      }
    } catch (_) {}
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
            return const Center(
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
                      errorBuilder: (_, error, stackTrace) => Container(
                        height: 550,
                        width: double.infinity,
                        color: AppColors.cardDark,
                        child: const Icon(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _toggleWatchList(movie),
                              icon: Icon(
                                _isInWatchList ? Icons.bookmark : Icons.bookmark_border,
                                color: _isInWatchList ? AppColors.primary : AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          child: const Icon(
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
                          const SizedBox(height: 8),
                          Text('${movie.year}', style: AppTextStyles.movieYear),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          localizations?.watch ?? 'Watch',
                          style: AppTextStyles.watchButton,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                      const SizedBox(height: 32),
                      Text(
                        localizations?.screenShots ?? 'Screen Shots',
                        style: AppTextStyles.sectionHeader,
                      ),
                      const SizedBox(height: 16),
                      ...movie.screenshots.map(
                            (image) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              height: 170,
                              width: double.infinity,
                              errorBuilder: (_, error, stackTrace) => Container(
                                height: 220,
                                width: double.infinity,
                                color: AppColors.cardDark,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Similar',
                        style: AppTextStyles.sectionHeader,
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<List<MovieSuggestionEntity>>(
                        future: _movieSuggestionsFuture,
                        builder: (context, suggestionSnapshot) {
                          if (suggestionSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }
                          if (!suggestionSnapshot.hasData ||
                              suggestionSnapshot.data!.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          final similarMovies = suggestionSnapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: similarMovies.length > 4
                                ? 4
                                : similarMovies.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                          errorBuilder: (_, error, stackTrace) =>
                                              Container(
                                                color: AppColors.cardDark,
                                                child: const Icon(
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
                                          padding: const EdgeInsets.symmetric(
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
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
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
                      const SizedBox(height: 16),
                      Text(
                        localizations?.summary ?? 'Summary',
                        style: AppTextStyles.sectionHeader,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.descriptionFull.isNotEmpty
                            ? movie.descriptionFull
                            : movie.descriptionIntro,
                        style: AppTextStyles.summaryText,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        localizations?.cast ?? 'Cast',
                        style: AppTextStyles.sectionHeader,
                      ),
                      const SizedBox(height: 16),
                      ...movie.cast.map(
                            (member) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(8),
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
                                  errorBuilder: (_, error, stackTrace) =>
                                      Container(
                                        width: 65,
                                        height: 65,
                                        color: Colors.grey,
                                        child: const Icon(Icons.person),
                                      ),
                                )
                                    : Container(
                                  width: 65,
                                  height: 65,
                                  color: Colors.grey,
                                  child: const Icon(Icons.person),
                                ),
                              ),
                              const SizedBox(width: 16),
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
                      const SizedBox(height: 32),
                      Text(
                        localizations?.genres ?? 'Genres',
                        style: AppTextStyles.sectionHeader,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: movie.genres
                            .map(
                              (genre) => Container(
                            padding: const EdgeInsets.symmetric(
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
                      const SizedBox(height: 50),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 10),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }
}