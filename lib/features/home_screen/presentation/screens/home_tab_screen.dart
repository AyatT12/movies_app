import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/movie_model.dart';
import '../widgets/movie_card.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final HomeRemoteDataSource _dataSource = HomeRemoteDataSource();
  late Future<List<MovieModel>> _moviesFuture;
  late PageController _pageController;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _dataSource.getMovies();
    _pageController = PageController(viewportFraction: 0.62, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<MovieModel>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.red),
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No movies available',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          final movies = snapshot.data!;
          final currentMovie = movies[_focusedIndex % movies.length];

          return Stack(
            children: [

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 520,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      currentMovie.mediumCoverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.15),
                            Colors.black.withOpacity(0.6),
                            AppColors.background,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),


                    Center(
                      child: Image.asset(
                        AppAssets.availableNow,
                        height: 93,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading availableNow image: $error');
                          return const SizedBox(height: 42);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),


                    SizedBox(
                      height: 330,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: movies.length,
                        onPageChanged: (index) {
                          setState(() {
                            _focusedIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final isCenter = index == _focusedIndex;
                          return AnimatedScale(
                            scale: isCenter ? 1.0 : 0.84,
                            duration: const Duration(milliseconds: 250),
                            child: MovieCard(
                              movie: movies[index],
                              width: 215,
                              height: 310,
                              borderRadius: 16,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),


                    Center(
                      child: Image.asset(
                        AppAssets.watchNow,
                        height: 146,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading watchNow image: $error');
                          return const SizedBox(height: 48);
                        },
                      ),
                    ),

                    const SizedBox(height: 24),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Action',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'See More',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                                size: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),


                    SizedBox(
                      height: 195,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: movies.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return MovieCard(
                            movie: movies[index],
                            width: 146,
                            height: 220,
                            borderRadius: 16,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}