import 'package:cay_khe/ui/views/profile/blocs/follow_item/follow_item_provider.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../../dtos/user_metrics.dart';
import '../../../../router.dart';
import '../../../../widgets/user_avatar.dart';
import '../../blocs/follow_item/follow_item_bloc.dart';

class FollowTabItem extends StatelessWidget {
  final UserMetrics userMetrics;
  final bool isFollowingsTab;

  const FollowTabItem({
    super.key,
    required this.userMetrics,
    required this.isFollowingsTab,
  });

  @override
  Widget build(BuildContext context) {
    return FollowItemBlocProvider(
        isFollowersTab: isFollowingsTab,
        child: BlocListener<FollowItemBloc, FollowItemState>(
          listener: (context, state) {
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
                imageUrl: userMetrics.avatarUrl,
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
                      appRouter
                          .go('/profile/${userMetrics.username}', extra: {})
                    },
                    child: Text(
                      userMetrics.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '@${userMetrics.username}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Row(children: [
                _buildFieldCount(
                    Icons.favorite_border_outlined, userMetrics.followerCount),
                _buildFieldCount(
                    Icons.backup_table_rounded, userMetrics.postCount),
                _buildFieldCount(
                    Icons.category_outlined, userMetrics.seriesCount),
              ]),
              if (isFollowingsTab) _buildFollowButton(context, state)
            ],
          ),
        ],
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: ActionChip(
        backgroundColor:
            state.isFollowing ? Colors.indigoAccent[200] : Colors.white,
        label: Text(state.isFollowing ? 'Đang theo dõi' : 'Theo dõi'),
        side: const BorderSide(color: Colors.indigoAccent),
        labelStyle: TextStyle(
            color: state.isFollowing ? Colors.white : Colors.indigoAccent),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        onPressed: () {
          if (state.isFollowing) {
            context.read<FollowItemBloc>().add(UnfollowEvent(
                isFollowed: state.isFollowing, username: userMetrics.username));
          } else {
            context.read<FollowItemBloc>().add(FollowEvent(
                isFollowed: state.isFollowing, username: userMetrics.username));
          }
        },
      ),
    );
  }
}
