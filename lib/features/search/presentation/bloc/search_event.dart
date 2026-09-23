part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchMoviesEvent extends SearchEvent {
  final String query;
  SearchMoviesEvent(this.query);
}

class ClearSearchEvent extends SearchEvent {}
