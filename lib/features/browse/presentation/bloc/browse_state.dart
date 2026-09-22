part of 'browse_bloc.dart';

abstract class BrowseState {}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {}

class BrowseSuccess extends BrowseState {
  final List<MovieModel> allMovies;
  final List<String> genres;

  BrowseSuccess({required this.allMovies, required this.genres});
}

class BrowseError extends BrowseState {
  final String message;

  BrowseError(this.message);
}
