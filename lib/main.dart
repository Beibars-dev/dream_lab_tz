import 'package:dream_lab_app/features/data/repositories/post_repository.dart';
import 'package:dream_lab_app/features/domain/usecases/get_all_posts_usecase.dart';
import 'package:dream_lab_app/features/domain/usecases/get_post_by_id_usecase.dart';
import 'package:dream_lab_app/features/domain/usecases/search_post_usecase.dart';
import 'package:dream_lab_app/features/presentation%20/bloc/post_detail_bloc.dart';
import 'package:dream_lab_app/features/presentation%20/bloc/post_list_bloc.dart';
import 'package:dream_lab_app/features/presentation%20/bloc/post_search_bloc.dart';
import 'package:dream_lab_app/features/presentation%20/screens/home_screen.dart';
import 'package:dream_lab_app/features/presentation%20/screens/post_detail_screen.dart';
import 'package:dream_lab_app/features/presentation%20/screens/post_list_screen.dart';
import 'package:dream_lab_app/features/presentation%20/screens/post_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final postRepository = PostRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostListBloc(
            GetAllPostsUseCase(postRepository),
          ),
        ),
        BlocProvider(
          create: (context) => PostDetailBloc(
            GetPostByIdUseCase(postRepository),
          ),
        ),
        BlocProvider(
          create: (context) => PostSearchBloc(
            SearchPostUseCase(postRepository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DreamLab',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/post-detail': (context) => PostDetailScreen(),
          '/post-search': (context) => PostSearchScreen(),
          '/post-list': (context) => PostListScreen(),
        },
      ),
    );
  }
}
