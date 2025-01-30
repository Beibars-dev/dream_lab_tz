import 'package:dream_lab_app/features/data/model/post.dart';
import 'package:dream_lab_app/features/domain/usecases/get_all_posts_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class PostListEvent {}

class LoadPosts extends PostListEvent {
  final int page;
  LoadPosts({this.page = 1});
}

// States
abstract class PostListState {}

class PostListInitial extends PostListState {}

class PostListLoading extends PostListState {}

class PostListLoaded extends PostListState {
  final List<Post> posts;
  final bool hasReachedEnd;

  PostListLoaded(this.posts, {this.hasReachedEnd = false});
}

class PostListError extends PostListState {
  final String message;
  PostListError(this.message);
}

// BLoC
class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final GetAllPostsUseCase getAllPostsUseCase;
  final List<Post> _posts = [];

  PostListBloc(this.getAllPostsUseCase) : super(PostListInitial()) {
    on<LoadPosts>((event, emit) async {
      try {
        if (event.page == 1) {
          emit(PostListLoading());
          _posts.clear();
        }

        final newPosts = await getAllPostsUseCase.execute(
          page: event.page,
          limit: 20,
        );

        _posts.addAll(newPosts);
        emit(PostListLoaded(
          List.from(_posts),
          hasReachedEnd: newPosts.isEmpty,
        ));
      } catch (e) {
        emit(PostListError(e.toString()));
      }
    });
  }
}
