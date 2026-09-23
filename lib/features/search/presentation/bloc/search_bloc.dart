import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home_screen/data/movie_model.dart';
import '../../domain/repositories/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc(this.searchRepository) : super(SearchInitial()) {
    on<SearchMoviesEvent>((event, emit) async {
      if (event.query.isEmpty) {
        emit(SearchInitial());
        return;
      }

      emit(SearchLoading());
      try {
        final movies = await searchRepository.searchMovies(event.query);
        emit(SearchSuccess(movies));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    on<ClearSearchEvent>((event, emit) {
      emit(SearchInitial());
    });
  }
}
