import 'package:cay_khe/blocs/post_bloc.dart';
import 'package:cay_khe/ui/views/posts/posts_view.dart';
import 'package:cay_khe/ui/views/posts/widgets/left_menu.dart';
import 'package:cay_khe/ui/views/posts/widgets/post/posts_feed.dart';
import 'package:cay_khe/ui/views/posts/widgets/post_follow/posts_feed_follow.dart';
import 'package:cay_khe/ui/views/posts/widgets/right_page/right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({super.key, this.indexSelected = 0, required this.params});
  final Map<String, String> params;
  final int indexSelected;
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  late PostBloc postBloc;
  late List<NavigationPost> listSelectBtn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postBloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    listSelectBtn = [
      NavigationPost(index: 0, text: "Mới nhất", path: "/viewquestion/${converPageParams(widget.params)}",
          widget: PostsFeed(page: getPage(widget.params['page'] ?? "1"), limit: 10, isQuestion: true, params: widget.params,)),
      NavigationPost(index: 1, text: "Đang theo dõi", path: "/viewquestionfollow/${converPageParams(widget.params)}",
          widget: PostsFeedFollow(page: getPage(widget.params['page'] ?? "1"), limit: 10, isQuestion: true, params: widget.params,)),
      NavigationPost(index: 2, text: "Đã Bookmark", widget: Container())
    ];
    listSelectBtn[widget.indexSelected].isSelected = true;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
          child: Container(
            width: constraints.maxWidth,
            child: Center(
              child: Container(
                width: 1200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: LeftMenu(listSelectBtn: listSelectBtn),
                    ),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: listSelectBtn[widget.indexSelected].widget,
                      ),
                    ),
                    Container(
                      width: 280,
                      child: Right(page: 1, limit: 5, isQuestion: false,),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}