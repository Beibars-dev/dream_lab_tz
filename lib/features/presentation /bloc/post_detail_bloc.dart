// Events
import 'package:dream_lab_app/features/data/model/post.dart';
import 'package:dream_lab_app/features/domain/usecases/get_post_by_id_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PostDetailEvent {}

class LoadPostDetail extends PostDetailEvent {
  final int id;
  LoadPostDetail(this.id);
}

// States
abstract class PostDetailState {}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final Post post;
  PostDetailLoaded(this.post);
}

class PostDetailError extends PostDetailState {
  final String message;
  PostDetailError(this.message);
}

// BLoC
class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetPostByIdUseCase getPostByIdUseCase;

  PostDetailBloc(this.getPostByIdUseCase) : super(PostDetailInitial()) {
    on<LoadPostDetail>((event, emit) async {
      try {
        emit(PostDetailLoading());
        final post = await getPostByIdUseCase.execute(event.id);
        emit(PostDetailLoaded(post));
      } catch (e) {
        emit(PostDetailError(e.toString()));
      }
    });
  }
}
