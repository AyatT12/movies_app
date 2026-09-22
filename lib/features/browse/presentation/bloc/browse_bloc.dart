import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home_screen/data/movie_model.dart';
import '../../domain/repositories/browse_repository.dart';

part 'browse_event.dart';
part 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final BrowseRepository browseRepository;

  BrowseBloc(this.browseRepository) : super(BrowseInitial()) {
    on<FetchBrowseDataEvent>((event, emit) async {
      emit(BrowseLoading());
      try {
        final movies = await browseRepository.getMovies();
        final Set<String> genreSet = {};
        for (var movie in movies) {
          for (var genre in movie.genres) {
            if (genre.isNotEmpty) {
              genreSet.add(genre);
            }
          }
        }
        emit(BrowseSuccess(allMovies: movies, genres: genreSet.toList()));
      } catch (e) {
        emit(BrowseError(e.toString()));
      }
    });
  }
}
