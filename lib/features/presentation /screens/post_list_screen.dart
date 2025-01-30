// lib/presentation/screens/paginated_posts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_lab_app/features/presentation%20/bloc/post_list_bloc.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  }

  void _loadInitialPosts() {
    context.read<PostListBloc>().add(LoadPosts(page: 1));
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Load more when user scrolls to 70% of the list
    if (currentScroll >= (maxScroll * 0.7)) {
      _loadMorePosts();
    }
  }

  void _loadMorePosts() {
    _isLoadingMore = true;
    _currentPage++;
    context.read<PostListBloc>().add(LoadPosts(page: _currentPage));
    _isLoadingMore = false;
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    context.read<PostListBloc>().add(LoadPosts(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text('All Posts'),
      ),
      body: BlocBuilder<PostListBloc, PostListState>(
        builder: (context, state) {
          if (state is PostListInitial ||
              (state is PostListLoading && _currentPage == 1)) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostListLoaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: state.hasReachedEnd
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.posts.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = state.posts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      tileColor: Colors.grey.shade100,
                      title: Text(
                        post.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            post.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/post-detail',
                        arguments: post.id,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is PostListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onRefresh,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
