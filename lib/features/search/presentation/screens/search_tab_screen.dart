import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../home_screen/presentation/screens/movie_details_screen.dart';
import '../../../home_screen/presentation/widgets/movie_card.dart';
import '../bloc/search_bloc.dart';

class SearchTabScreen extends StatefulWidget {
  const SearchTabScreen({super.key});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, SearchBloc bloc) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      bloc.add(SearchMoviesEvent(query.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    double childAspectRatio = 0.68;

    return BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: Builder(
        builder: (context) {
          final searchBloc = BlocProvider.of<SearchBloc>(context);

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: AppColors.white),
                      onChanged: (value) => _onSearchChanged(value, searchBloc),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: AppColors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.white,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.white,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  searchBloc.add(ClearSearchEvent());
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.textfield,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          if (state is SearchLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          } else if (state is SearchSuccess) {
                            if (state.movies.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No movies found',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }
                            return GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: childAspectRatio,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: state.movies.length,
                              itemBuilder: (context, index) {
                                final movie = state.movies[index];
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
                            );
                          } else if (state is SearchError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  color: AppColors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.movie_creation_outlined,
                                  size: 60,
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Search for your favorite movies',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
