import 'package:cay_khe/ui/views/profile/blocs/posts_tab/posts_tab_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/post_repository.dart';

class PostsTabBlocProvider extends StatelessWidget {
  final Widget child;
  final String username;
  final int page;
  final int limit;
  final bool isQuestion;

  const PostsTabBlocProvider({
    super.key,
    required this.child,
    required this.username,
    required this.page,
    required this.limit,
    required this.isQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsTabBloc>(
      create: (context) {
        final bloc = PostsTabBloc(postRepository: PostRepository());
        bloc.add(LoadPostsEvent(
          username: username,
          page: page,
          limit: limit,
          isQuestion: isQuestion,
        ));
        return bloc;
      },
      child: child,
    );
  }
}
