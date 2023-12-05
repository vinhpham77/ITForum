import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/dtos/limit_page.dart';
import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/views/user_profile/widgets/custom_tab.dart';
import 'package:cay_khe/ui/views/user_profile/widgets/posts_tab.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

import '../../router.dart';

class UserProfile extends StatefulWidget {
  final String username;
  final int selectedIndex;
  final Map<String, dynamic> params;

  const UserProfile(
      {super.key,
      required this.username,
      required this.selectedIndex,
      required this.params});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final int _left = 4;
  final int _right = 1;
  late int selectedIndex;
  late bool isDeletable;
  late int currentPage;
  late int limit;
  late List<Map<String, dynamic>> tabs;

  @override
  void initState() {
    super.initState();
    isDeletable = JwtPayload.sub == widget.username;
    loadTabStates();
  }

  void loadPagingStates() {
    currentPage = widget.params['page'] != null ? widget.params['page']! : 1;
    limit =
        widget.params['limit'] != null ? widget.params['limit']! : limitPage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: bodyVerticalSpace),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: maxContent),
            margin: const EdgeInsets.symmetric(horizontal: horizontalSpace),
            child: Row(
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: UserAvatar(
                          imageUrl: JwtPayload.avatarUrl,
                          size: 60,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            JwtPayload.displayName!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '@${JwtPayload.sub}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                    ),
                    child: const Text(
                      'Theo dõi',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
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
                              CustomTab(isActive: tab == tabs[widget.selectedIndex],
                              onTap: () => handleTabChange(tabs.indexOf(tab)),
                              child: Text('${tab['title']}', style: const TextStyle(fontSize: 14),)),
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
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: maxContent),
            margin: const EdgeInsets.symmetric(horizontal: horizontalSpace),
            child: Row(
              children: [
                Expanded(
                  flex: _left,
                  child: Container(
                    transform: Matrix4.translationValues(-8.0, 0, 0),
                    child: tabs[widget.selectedIndex]['widget']!,
                  ),
                ),
                Expanded(
                    flex: _right, child: Container(child: Text('okokokok')))
              ],
            ),
          ),
        ],
      ),
    );
  }

  handleTabChange(int index) {
    appRouter.go(tabs[index]['path']!, extra: {'page': 1, 'limit': limit});
  }

  void loadTabStates() {
    tabs = [
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
        'widget': Text('Series'),
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
    loadPagingStates();
    return PostsTab(isQuestion: isQuestion, username: widget.username, page: currentPage, limit: limit);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
