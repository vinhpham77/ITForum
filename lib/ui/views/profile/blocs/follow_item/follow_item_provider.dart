import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/follow_repository.dart';
import 'follow_item_bloc.dart';

class FollowItemBlocProvider extends StatelessWidget {
  final Widget child;
  final bool isFollowersTab;

  const FollowItemBlocProvider({super.key, required this.child, required this.isFollowersTab});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowItemBloc>(
      create: (context) => FollowItemBloc(followRepository: FollowRepository(), isFollowing: isFollowersTab),
      child: child,
    );
  }
}