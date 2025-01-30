import 'package:dream_lab_app/features/data/model/post.dart';
import 'package:dream_lab_app/features/data/repositories/post_repository.dart';

class GetPostByIdUseCase {
  final PostRepository repository;

  GetPostByIdUseCase(this.repository);

  Future<Post> execute(int id) {
    return repository.getPostById(id);
  }
}
