// Events
import 'package:dream_lab_app/features/data/model/post.dart';
import 'package:dream_lab_app/features/domain/usecases/search_post_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PostSearchEvent {}

class SearchPost extends PostSearchEvent {
  final int id;
  SearchPost(this.id);
}

// States
abstract class PostSearchState {}

class PostSearchInitial extends PostSearchState {}

class PostSearchLoading extends PostSearchState {}

class PostSearchLoaded extends PostSearchState {
  final List<Post> posts;
  PostSearchLoaded(this.posts);
}

class PostSearchError extends PostSearchState {
  final String message;
  PostSearchError(this.message);
}

// BLoC
class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  final SearchPostUseCase searchPostUseCase;

  PostSearchBloc(this.searchPostUseCase) : super(PostSearchInitial()) {
    on<SearchPost>((event, emit) async {
      try {
        emit(PostSearchLoading());
        final posts = await searchPostUseCase.execute(event.id);
        emit(PostSearchLoaded(posts));
      } catch (e) {
        emit(PostSearchError(e.toString()));
      }
    });
  }
}
