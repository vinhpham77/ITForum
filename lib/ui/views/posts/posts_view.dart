import 'package:cay_khe/ui/views/posts/widgets/bookmark/bookmark_feed.dart';
import 'package:cay_khe/ui/views/posts/widgets/follow/follow_feed.dart';
import 'package:cay_khe/ui/views/posts/widgets/left_menu.dart';
import 'package:cay_khe/ui/views/posts/widgets/post/posts_feed.dart';
import 'package:cay_khe/ui/views/posts/widgets/right_page/right.dart';
import 'package:cay_khe/ui/views/posts/widgets/series/series_feed.dart';
import 'package:flutter/material.dart';

import '../../../dtos/jwt_payload.dart';
import '../../common/app_constants.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key, this.indexSelected = 0, required this.params});

  final Map<String, String> params;
  final int indexSelected;

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  late List<NavigationPost> listSelectBtn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNavigation();
  }

  @override
  void didUpdateWidget(PostsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    getNavigation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getNavigation() {
    if (JwtPayload.sub == null) {
      listSelectBtn = navi;
    } else {
      listSelectBtn = naviSignin;
    }
      listSelectBtn[widget.indexSelected].isSelected = true;
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: maxContent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: LeftMenu(listSelectBtn: listSelectBtn),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: listSelectBtn[widget.indexSelected].widget,
                    ),
                  ),
                  const SizedBox(
                    width: 280,
                    child: Right(
                      page: 1,
                      limit: 5,
                      isQuestion: false,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<NavigationPost> get naviSignin =>
      [
        NavigationPost(
            index: 0,
            text: "Mới nhất",
            path: "/viewposts",
            widget: PostsFeed(
              page: getPage(widget.params['page'] ?? "1"),
              limit: 10,
              isQuestion: false,
              params: widget.params,
            )),
        NavigationPost(
            index: 1,
            text: "Series",
            path: "/viewseries",
            widget: SeriesFeed(
              page: getPage(widget.params['page'] ?? "1"),
              limit: 10,
              params: widget.params,
            )),
        NavigationPost(
            index: 2,
            text: "Đang theo dõi",
            path: "/viewfollow",
            widget: FollowFeed(
              page: getPage(widget.params['page'] ?? "1"),
              limit: 10,
              params: widget.params,
            )),
        NavigationPost(
            index: 3,
            text: "Bookmark của tôi",
            path: "/viewbookmark",
            widget: BookmarkFeed(
              username: JwtPayload.sub,
              page: getPage(widget.params['page'] ?? "1"),
              limit: 10,
              isQuestion: false,
              params: widget.params,
            )),
      ];

  List<NavigationPost> get navi =>
      [
        NavigationPost(
            index: 0,
            text: "Mới nhất",
            path: "/viewposts",
            widget: PostsFeed(
              page: getPage(widget.params['page'] ?? "1"),
              limit: 10,
              isQuestion: false,
              params: widget.params,
            )),
        NavigationPost(
            index: 1,
            text: "Series",
            path: "/viewseries",
            widget: SeriesFeed(
              page: getPage(widget.params['page'] ?? "1"),
              limit: 10,
              params: widget.params,
            )),
      ];
}

String convertPageParams(Map<String, String> params) {
  return params.entries.map((e) => '${e.key}=${e.value}').join('&');
}

String convertParams(Map<String, String> params) {
  params["page"] = "1";
  return params.entries.map((e) => '${e.key}=${e.value}').join('&');
}

int getPage(String page) {
  return int.parse(page == 'null' || page == '' ? '1' : page);
}

class NavigationPost {
  final int index;
  String text;
  bool isSelected;
  String path;
  Widget widget;

  NavigationPost({required this.index,
    this.text = "",
    this.isSelected = false,
    this.path = "",
    required this.widget});
}
