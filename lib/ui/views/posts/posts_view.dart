import 'package:cay_khe/blocs/post_bloc.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/ui/views/posts/widgets/left_menu.dart';
import 'package:cay_khe/ui/widgets/pagination.dart';
import 'package:cay_khe/ui/widgets/post_feed_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cay_khe/models/post_aggregation.dart';

import '../../../dtos/notify_type.dart';
import '../../common/utils/message_from_exception.dart';
import '../../widgets/notification.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key, this.indexSelected = 0, required this.params});
  final Map<String, String> params;
  final int indexSelected;
  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  late ResultCount<PostAggregation> resultCount = ResultCount(resultList: [], count: 0);
  late PostBloc postBloc;
  List<NavigationPost> listSelectBtn = [
    NavigationPost(index: 0, text: "Mới nhất"),
    NavigationPost(index: 1, text: "Đang theo dõi"),
    NavigationPost(index: 2, text: "Series"),
    NavigationPost(index: 3, text: "Bookmark của tôi")
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    listSelectBtn[widget.indexSelected].isSelected = true;
    postBloc = PostBloc(context: context);
    postBloc.loadPost(params: widget.params);
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
                        child: StreamBuilder(
                            stream: postBloc.postStream,
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                resultCount = snapshot.data;
                                return Column(
                                  children: [
                                    Column(
                                        children:resultCount.resultList.map((e) {
                                          return PostFeedItem(postAggregation: e);
                                        }).toList()
                                    ),
                                    Pagination(path: "/viewposts", totalItem: resultCount.count, params: widget.params, selectedPage: int.parse(widget.params['page'] ?? '1'),)
                                  ],
                                );
                              }
                              return Center(child:CircularProgressIndicator());
                            }
                        )
                      ),
                    ),
                    Container(width: 280,)
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

class NavigationPost {
  final int index;
  String text;
  bool isSelected;
  String route;
  NavigationPost({required this.index,this.text = "", this.isSelected = false, this.route = ""});
}