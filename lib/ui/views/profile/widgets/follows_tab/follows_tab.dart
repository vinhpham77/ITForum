import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/ui/views/profile/widgets/follows_tab/follow_tab_item.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/pagination_states.dart';
import '../../../../widgets/pagination2.dart';
import '../../blocs/follows_tab/follows_tab_bloc.dart';
import '../../blocs/follows_tab/follows_tab_provider.dart';

class FollowsTab extends StatelessWidget {
  final String username;
  final int page;
  final int limit;
  final bool isFollowers;

  const FollowsTab({
    super.key,
    required this.username,
    required this.page,
    required this.limit,
    required this.isFollowers,
  });

  bool get isAuthorised => JwtPayload.sub != null && JwtPayload.sub == username;

  String get object => isFollowers ? "followers" : "followings";

  String get message => isFollowers ? "người theo dõi" : "đang theo dõi";

  @override
  Widget build(BuildContext context) {
    return FollowsTabBlocProvider(
        username: username,
        page: page,
        limit: limit,
        isFollowed: isFollowers,
        child: BlocListener<FollowsTabBloc, FollowsTabState>(
          listener: (context, state) {
            if (state is FollowsLoadErrorState) {
              showTopRightSnackBar(context, state.message, NotifyType.error);
            }
          },
          child: BlocBuilder<FollowsTabBloc, FollowsTabState>(
            builder: (context, state) {
              if (state is FollowsEmptyState) {
                return _buildSimpleContainer(
                  child: Text(
                    "Không có $message ${isFollowers ? 'nào' : 'ai'}!",
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }
              else if (state is FollowsSubState) {
                return Column(
                  children: [
                    _buildFollowList(context, state),
                    _buildPagination(state),
                  ],
                );
              } else if (state is FollowsLoadErrorState) {
                return _buildSimpleContainer(
                    child: Center(child: Text(state.message)));
              }

              return _buildSimpleContainer(
                  child: const Center(child: CircularProgressIndicator()));
            },
          ),
        ));
  }

  Container _buildSimpleContainer({required Widget child}) => Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: child);

  Widget _buildFollowList(BuildContext context, FollowsSubState state) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Wrap(
        spacing: 20,
        children: [
          for (var userStats in state.userStatsList.resultList)
            FollowTabItem(
              userStats: userStats,
              isFollowingsTab: !isFollowers,
              isAuthorised: isAuthorised,
            ),
        ],
      ),
    );
  }

  Pagination2 _buildPagination(FollowsSubState state) {
    return Pagination2(
        pagingStates: PaginationStates(
            count: state.userStatsList.count,
            limit: limit,
            currentPage: page,
            range: 2,
            path: "/profile/$username/$object",
            params: {}));
  }
}
