import 'package:dream_lab_app/features/presentation%20/bloc/post_search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostSearchScreenState createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {
  final _controller = TextEditingController();

  void _searchPost() {
    final id = int.tryParse(_controller.text);
    if (id != null) {
      context.read<PostSearchBloc>().add(SearchPost(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search Post'),
        backgroundColor: Colors.grey.shade100,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter Post ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                  ),
                  onPressed: _searchPost,
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<PostSearchBloc, PostSearchState>(
                builder: (context, state) {
                  if (state is PostSearchLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PostSearchLoaded) {
                    if (state.posts.isEmpty) {
                      return Center(child: Text('No posts found'));
                    }
                    return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return ListTile(
                          title: Text(
                            post.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(post.content,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/post-detail',
                            arguments: post.id,
                          ),
                        );
                      },
                    );
                  } else if (state is PostSearchError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(
                    child: Text('Enter a post ID to search'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
