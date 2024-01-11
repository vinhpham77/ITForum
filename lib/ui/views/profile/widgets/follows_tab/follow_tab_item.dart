import 'package:cay_khe/ui/views/profile/blocs/follow_item/follow_item_provider.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../../dtos/user_stats.dart';
import '../../../../router.dart';
import '../../../../widgets/user_avatar.dart';
import '../../blocs/follow_item/follow_item_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';

class FollowTabItem extends StatelessWidget {
  final UserStats userStats;
  final bool isFollowingsTab;
  final bool isAuthorised;

  const FollowTabItem({
    super.key,
    required this.userStats,
    required this.isFollowingsTab,
    required this.isAuthorised,
  });

  @override
  Widget build(BuildContext context) {
    final ProfileBloc profileBloc = context.read<ProfileBloc>();
    return FollowItemBlocProvider(
        isFollowersTab: isFollowingsTab,
        child: BlocListener<FollowItemBloc, FollowItemState>(
          listener: (context, state) {
            if (state is FollowSuccessState) {
              final state = profileBloc.state as ProfileSubState;
              profileBloc.add(SuccessFollowItemEvent(
                  user: state.user,
                  isFollowing: state.isFollowing,
                  tagCounts: state.tagCounts,
                  profileStats: state.profileStats));
            } else if (state is UnfollowSuccessState) {
              final state = profileBloc.state as ProfileSubState;
              profileBloc.add(SuccessUnfollowItemEvent(
                  user: state.user,
                  isFollowing: state.isFollowing,
                  tagCounts: state.tagCounts,
                  profileStats: state.profileStats));
            }
            if (state is FollowOperationErrorState) {
              showTopRightSnackBar(context, state.message, NotifyType.error);
            }
          },
          child: BlocBuilder<FollowItemBloc, FollowItemState>(
            builder: (context, state) {
              if (state is FollowItemSubState) {
                return _buildFollowItem(context, state);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }

  Widget _buildFollowItem(BuildContext context, FollowItemSubState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: UserAvatar(
                imageUrl: userStats.avatarUrl,
                size: 54,
              )),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    hoverColor: Colors.black12,
                    onTap: () => {
                      appRouter.go('/profile/${userStats.username}', extra: {})
                    },
                    child: Text(
                      userStats.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '@${userStats.username}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Row(children: [
                _buildFollowerCount(state),
                _buildFieldCount(
                    Icons.backup_table_rounded, userStats.postCount),
                _buildFieldCount(
                    Icons.category_outlined, userStats.seriesCount),
              ]),
              if (isFollowingsTab && isAuthorised)
                _buildFollowButton(context, state)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerCount(FollowItemSubState state) {
    if (state is UnfollowSuccessState) {
      return _buildFieldCount(
          Icons.favorite_border_outlined, userStats.followerCount - 1);
    }

    return _buildFieldCount(
        Icons.favorite_border_outlined, userStats.followerCount);
  }

  _buildFieldCount(IconData icon, int count) {
    return Container(
      margin: const EdgeInsets.only(top: 2, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(
              icon,
              size: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 3),
          Text('$count',
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, FollowItemSubState state) {
    bool isWaiting = state is FollowOperationWaitingState;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ActionChip(
            backgroundColor:
            state.isFollowing ? Colors.indigoAccent[200] : Colors.white,
            label: Text(state.isFollowing ? 'Đang theo dõi' : 'Theo dõi'),
            side: const BorderSide(color: Colors.indigoAccent),
            labelStyle: TextStyle(
                color: state.isFollowing ? Colors.white : Colors.indigoAccent),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            onPressed: isWaiting
                ? null
                : () {
              if (state.isFollowing) {
                context.read<FollowItemBloc>().add(
                    HandleUnfollowItemEvent(
                        isFollowed: state.isFollowing,
                        username: userStats.username));
              } else {
                context.read<FollowItemBloc>().add(HandleFollowItemEvent(
                    isFollowed: state.isFollowing,
                    username: userStats.username));
              }
            },
          ),
          if (isWaiting)
            const SizedBox(
                height: 16, width: 16, child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
