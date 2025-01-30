import 'package:dream_lab_app/features/data/model/post.dart';
import 'package:dream_lab_app/features/data/repositories/post_repository.dart';

class GetAllPostsUseCase {
  final PostRepository repository;

  GetAllPostsUseCase(this.repository);

  Future<List<Post>> execute({int page = 1, int limit = 20}) {
    return repository.getAllPosts(page: page, limit: limit);
  }
}
