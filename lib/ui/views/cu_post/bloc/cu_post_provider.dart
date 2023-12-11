import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/repositories/tag_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cu_post_bloc.dart';

class CuPostBlocProvider extends StatelessWidget {
  final Widget child;
  final String? id;
  final bool isQuestion;

  const CuPostBlocProvider(
      {super.key,
      required this.child,
      this.id,
      required this.isQuestion});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CuPostBloc>(
      create: (context) {
        final bloc = CuPostBloc(
            postRepository: PostRepository(), tagRepository: TagRepository());
        if (id == null) {
          bloc.add(InitEmptyPostEvent(isQuestion: isQuestion));
        } else {
          bloc.add(LoadPostEvent(id: id!, isQuestion: isQuestion));
        }

        return bloc;
      },
      child: child,
    );
  }
}
