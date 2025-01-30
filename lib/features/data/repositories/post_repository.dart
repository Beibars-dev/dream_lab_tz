import 'package:dio/dio.dart';
import 'package:dream_lab_app/features/data/model/post.dart';

class PostRepository {
  final Dio _dio;
  final String _baseUrl = 'https://jsonplaceholder.org';

  PostRepository() : _dio = Dio();

  Future<List<Post>> getAllPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/posts',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<Post> getPostById(int id) async {
    try {
      final response = await _dio.get('$_baseUrl/posts/$id');
      return Post.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }

  Future<List<Post>> searchPostById(int id) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/posts',
        queryParameters: {'id': id},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search post: $e');
    }
  }
}
