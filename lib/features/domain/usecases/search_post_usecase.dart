import 'package:dream_lab_app/features/data/model/post.dart';
import 'package:dream_lab_app/features/data/repositories/post_repository.dart';

class SearchPostUseCase {
  final PostRepository repository;

  SearchPostUseCase(this.repository);

  Future<List<Post>> execute(int id) {
    return repository.searchPostById(id);
  }
}
