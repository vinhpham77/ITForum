import 'package:cay_khe/dtos/limit_page.dart';
import 'package:cay_khe/models/user.dart';
import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/views/profile/blocs/profile/profile_bloc.dart';
import 'package:cay_khe/ui/views/profile/widgets/custom_tab.dart';
import 'package:cay_khe/ui/views/profile/widgets/posts_tab/posts_tab.dart';
import 'package:cay_khe/ui/views/profile/widgets/series_tab/series_tab.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dtos/jwt_payload.dart';
import '../../../dtos/notify_type.dart';
import '../../router.dart';
import '../../widgets/notification.dart';

class Profile extends StatefulWidget {
  final String username;
  final int selectedIndex;
  final Map<String, dynamic> params;

  const Profile(
      {super.key,
      required this.username,
      required this.selectedIndex,
      required this.params});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final int _left = 4;
  final int _right = 1;

  int get page => widget.params['page'] != null ? widget.params['page']! : 1;

  int get limit =>
      widget.params['limit'] != null ? widget.params['limit']! : limitPage;
  late List<Map<String, dynamic>> tabs;
  late ProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ProfileBloc()..add(LoadProfileEvent(username: widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => _bloc,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadedState) {
            tabs = getTabStates();
          } else if (state is ProfileNotFoundState) {
            appRouter.go('not-found');
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          } else if (state is ProfileErrorState) {
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadedState) {
              return Container(
                color: Colors.white.withOpacity(0.5),
                padding:
                    const EdgeInsets.symmetric(vertical: bodyVerticalSpace),
                child: Column(
                  children: [
                    buildUserContainer(context, state.user),
                    buildTabBar(),
                    Container(
                      constraints: const BoxConstraints(maxWidth: maxContent),
                      margin: const EdgeInsets.symmetric(
                          horizontal: horizontalSpace),
                      child: Row(
                        children: [buildTabView(), buildAnalysisView()],
                      ),
                    ),
                  ],
                ),
              );
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

  Expanded buildTabView() {
    return Expanded(
      flex: _left,
      child: Container(
        transform: Matrix4.translationValues(-8.0, 0, 0),
        child: tabs[widget.selectedIndex]['widget']!,
      ),
    );
  }

  Container buildTabBar() {
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
                      for (var tab in tabs)
                        CustomTab(
                            isActive: tab == tabs[widget.selectedIndex],
                            onTap: () => handleTabChange(tabs.indexOf(tab)),
                            child: Text(
                              '${tab['title']}',
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

  Container buildUserContainer(BuildContext context, User user) {
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
                    imageUrl: user.avatarUrl,
                    size: 68,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '@${user.username}',
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
          if (user.username == JwtPayload.sub)
            Padding(
              padding: const EdgeInsets.only(left: 80, right: 40),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                ),
                child: const Text(
                  'Theo dõi',
                ),
              ),
            ),
        ],
      ),
    );
  }

  handleTabChange(int index) {
    appRouter.go(tabs[index]['path']!, extra: {'page': 1, 'limit': limit});
  }

  List<Map<String, dynamic>> getTabStates() {
    return [
      {
        'title': 'Bài viết',
        'path': '/profile/${widget.username}/posts',
        'widget': buildPostTab(),
      },
      {
        'title': 'Câu hỏi',
        'path': '/profile/${widget.username}/questions',
        'widget': buildPostTab(isQuestion: true),
      },
      {
        'title': 'Series',
        'path': '/profile/${widget.username}/series',
        'widget': buildSeriesTab(),
      },
      {
        'title': 'Bookmark',
        'path': '/profile/${widget.username}/bookmarks',
        'widget': Text('Bookmark'),
      },
      {
        'title': 'Đang theo dõi',
        'path': '/profile/${widget.username}/following',
        'widget': Text('Đang theo dõi'),
      },
      {
        'title': 'Người theo dõi',
        'path': '/profile/${widget.username}/followers',
        'widget': Text('Người theo dõi'),
      },
      {
        'title': 'Cá nhân',
        'path': '/profile/${widget.username}/personal',
        'widget': Text('Cá nhân'),
      }
    ];
  }

  Widget buildPostTab({bool isQuestion = false}) {
    return PostsTab(
        isQuestion: isQuestion,
        username: widget.username,
        page: page,
        limit: limit);
  }

  Widget buildSeriesTab() {
    return SeriesTab(username: widget.username, page: page, limit: limit);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
