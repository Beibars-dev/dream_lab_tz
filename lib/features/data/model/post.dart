class Post {
  final int id;
  final String title;
  final String content;

  Post({
    required this.id,
    required this.title,
    required this.content,
  });
  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        title: json['title'] as String,
        content: json['content'] as String,
      );
}
