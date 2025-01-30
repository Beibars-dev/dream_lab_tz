import 'package:dream_lab_app/features/presentation%20/bloc/post_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final postId = ModalRoute.of(context)?.settings.arguments as int;
    context.read<PostDetailBloc>().add(LoadPostDetail(postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: Colors.grey.shade100,
      ),
      body: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          if (state is PostDetailLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostDetailLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.post.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  Text(state.post.content),
                  SizedBox(height: 16),
                ],
              ),
            );
          } else if (state is PostDetailError) {
            return Center(
              child: Text(state.message),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
