import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/dtos/limit_page.dart';
import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/views/profile/blocs/profile/profile_bloc.dart';
import 'package:cay_khe/ui/views/profile/widgets/custom_tab.dart';
import 'package:cay_khe/ui/views/profile/widgets/posts_tab/posts_tab.dart';
import 'package:cay_khe/ui/views/profile/widgets/series_tab/series_tab.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dtos/notify_type.dart';
import '../../router.dart';
import '../../widgets/notification.dart';
import 'blocs/profile/profile_provider.dart';

const int _left = 4;
const int _right = 1;

class Profile extends StatelessWidget {
  final String username;
  final int selectedIndex;
  final Map<String, dynamic> params;

  const Profile(
      {super.key,
      required this.username,
      required this.selectedIndex,
      required this.params});

  int get page => params['page'] != null ? params['page']! : 1;

  int get limit => params['limit'] ?? limitPage;

  @override
  Widget build(BuildContext context) {
    return ProfileBlocProvider(
      username: username,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileNotFoundState) {
            appRouter.go('not-found');
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          } else if (state is ProfileCommonErrorState) {
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSubState) {
              final tabs = getTabStates();
              return Container(
                color: Colors.white.withOpacity(0.5),
                padding:
                    const EdgeInsets.symmetric(vertical: bodyVerticalSpace),
                child: Column(
                  children: [
                    _buildUserContainer(context, state),
                    buildTabBar(tabs),
                    Container(
                      constraints: const BoxConstraints(maxWidth: maxContent),
                      margin: const EdgeInsets.symmetric(
                          horizontal: horizontalSpace),
                      child: Row(
                        children: [buildTabView(tabs), buildAnalysisView()],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoadErrorState) {
              return const Center(
                  child: Text('Có lỗi xảy ra. Vui lòng thử lại sau!',
                      style: TextStyle(color: Colors.red, fontSize: 20)));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Expanded buildAnalysisView() {
    return Expanded(flex: _right, child: Container(child: Text('ok')));
  }

  Expanded buildTabView(List<Map<String, dynamic>> tabs) {
    return Expanded(
      flex: _left,
      child: Container(
        transform: Matrix4.translationValues(-8.0, 0, 0),
        child: tabs[selectedIndex]['widget']!,
      ),
    );
  }

  Container buildTabBar(List<Map<String, dynamic>> tabs) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: horizontalSpace),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
          ),
          top: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxContent),
          child: Row(
            children: [
              Expanded(
                flex: _left,
                child: Container(
                  transform: Matrix4.translationValues(-20.0, 0, 0),
                  child: Row(
                    children: [
                      for (int index = 0; index < tabs.length; index++)
                        CustomTab(
                            isActive: index == selectedIndex,
                            onTap: () => appRouter.go(tabs[index]['path']!,
                                extra: {'page': 1, 'limit': limit}),
                            child: Text(
                              '${tabs[index]['title']}',
                              style: const TextStyle(fontSize: 14),
                            )),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: _right,
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildUserContainer(BuildContext context, ProfileSubState state) {
    return Container(
      constraints: const BoxConstraints(maxWidth: maxContent),
      margin: const EdgeInsets.symmetric(horizontal: horizontalSpace),
      child: Row(
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: UserAvatar(
                    imageUrl: state.user.avatarUrl,
                    size: 68,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user.displayName,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '@${state.user.username}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (state.user.username != JwtPayload.sub)
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 40),
              child: _buildFollowButton(context, state),
            ),
        ],
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, ProfileSubState state) {
    if (state.isFollowing) {
      return TextButton(
        onPressed: () => context.read<ProfileBloc>().add(
            UnfollowEvent(user: state.user, isFollowing: state.isFollowing)),
        style: TextButton.styleFrom(
          backgroundColor: Colors.indigoAccent.withOpacity(0.05),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        ),
        child: const Text(
          'Đang theo dõi',
        ),
      );
    }

    return OutlinedButton(
      onPressed: () => context
          .read<ProfileBloc>()
          .add(FollowEvent(user: state.user, isFollowing: state.isFollowing)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      ),
      child: const Text(
        'Theo dõi',
      ),
    );
  }

  handleTabChange(int index, List<Map<String, dynamic>> tabs) {
    appRouter.go(tabs[index]['path']!, extra: {'page': 1, 'limit': limit});
  }

  List<Map<String, dynamic>> getTabStates() {
    return [
      {
        'title': 'Bài viết',
        'path': '/profile/$username/posts',
        'widget': buildPostTab(),
      },
      {
        'title': 'Câu hỏi',
        'path': '/profile/$username/questions',
        'widget': buildPostTab(isQuestion: true),
      },
      {
        'title': 'Series',
        'path': '/profile/$username/series',
        'widget': buildSeriesTab(),
      },
      {
        'title': 'Bookmark',
        'path': '/profile/$username/bookmarks',
        'widget': Text('Bookmark'),
      },
      {
        'title': 'Đang theo dõi',
        'path': '/profile/$username/followings',
        'widget': Text('Đang theo dõi'),
      },
      {
        'title': 'Người theo dõi',
        'path': '/profile/$username/followers',
        'widget': Text('Người theo dõi'),
      },
      {
        'title': 'Cá nhân',
        'path': '/profile/$username/personal',
        'widget': Text('Cá nhân'),
      }
    ];
  }

  Widget buildPostTab({bool isQuestion = false}) {
    return PostsTab(
        isQuestion: isQuestion, username: username, page: page, limit: limit);
  }

  Widget buildSeriesTab() {
    return SeriesTab(username: username, page: page, limit: limit);
  }
}
