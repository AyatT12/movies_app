import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../home_screen/presentation/screens/movie_details_screen.dart';
import '../../../home_screen/presentation/widgets/movie_card.dart';
import '../bloc/browse_bloc.dart';

class BrowseTabScreen extends StatefulWidget {
  const BrowseTabScreen({super.key});

  @override
  State<BrowseTabScreen> createState() => _BrowseTabScreenState();
}

class _BrowseTabScreenState extends State<BrowseTabScreen> {
  int _selectedGenreIndex = 0;

  @override
  Widget build(BuildContext context) {
    double childAspectRatio = 0.68;

    return BlocProvider(
      create: (_) => sl<BrowseBloc>()..add(FetchBrowseDataEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<BrowseBloc, BrowseState>(
            builder: (context, state) {
              if (state is BrowseLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is BrowseSuccess) {
                if (state.genres.isEmpty) {
                  return const Center(
                    child: Text(
                      'No genres found',
                      style: TextStyle(color: AppColors.white),
                    ),
                  );
                }

                final selectedGenre = state.genres[_selectedGenreIndex];
                final filteredMovies = state.allMovies
                    .where((movie) => movie.genres.contains(selectedGenre))
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.genres.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final isSelected = index == _selectedGenreIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGenreIndex = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  state.genres[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.black
                                        : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: filteredMovies.isEmpty
                          ? const Center(
                              child: Text(
                                'No movies in this genre',
                                style: TextStyle(color: AppColors.grey),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: childAspectRatio,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: filteredMovies.length,
                              itemBuilder: (context, index) {
                                final movie = filteredMovies[index];
                                return MovieCard(
                                  movie: movie,
                                  width: double.infinity,
                                  height: double.infinity,
                                  borderRadius: 12,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => MovieDetailsScreen(
                                          movieId: movie.id,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              } else if (state is BrowseError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
