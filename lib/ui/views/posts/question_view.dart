import 'package:cay_khe/blocs/post_bloc.dart';
import 'package:cay_khe/dtos/limit_page.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/ui/views/posts/posts_view.dart';
import 'package:cay_khe/ui/views/posts/widgets/left_menu.dart';
import 'package:cay_khe/ui/views/posts/widgets/right_item.dart';
import 'package:cay_khe/ui/widgets/pagination.dart';
import 'package:cay_khe/ui/widgets/post_feed_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cay_khe/models/post_aggregation.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({super.key, this.indexSelected = 0, required this.params});
  final Map<String, String> params;
  final int indexSelected;
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  late PostBloc postBloc;
  List<NavigationPost> listSelectBtn = [
    NavigationPost(index: 0, text: "Mới nhất"),
    NavigationPost(index: 1, text: "Đang theo dõi"),
    NavigationPost(index: 2, text: "Đã Bookmark")
  ];
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
    int page = int.parse(widget.params['page'] ?? "1");
    widget.params['searchField'] = "tags";
    widget.params['searchContent'] = "HoiDap";
    listSelectBtn[widget.indexSelected].isSelected = true;
    postBloc = PostBloc(context: context);
    postBloc.loadPost(params: widget.params);
    postBloc.loadRightPost(fieldSearch: '', searchContent: '');
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
                          child: page < 1 ? Center(
                              child: Text(
                                "Lỗi! Page không thể nhỏ hơn 1",
                                style: TextStyle(color: Colors.red),)) :
                          StreamBuilder(
                              stream: postBloc.postStream,
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  ResultCount<PostAggregation> resultCount = snapshot.data;
                                  if(!resultCount.resultList.isEmpty)
                                    return Column(
                                      children: [
                                        Column(
                                          children: resultCount.resultList.map((e) {
                                            return PostFeedItem(postAggregation: e);
                                          }).toList()
                                        ),
                                        Pagination(path: "/viewposts", totalItem: resultCount.count, params: widget.params, selectedPage: page,)
                                      ],
                                    );
                                  else {
                                    int totalPasge = (resultCount.count/limitPage).ceil();

                                    if(page > totalPasge)
                                      return Center(child: Text("Lỗi! Tổng số trang là $totalPasge, không thể truy cập trang $page", style: TextStyle(color: Colors.red),));
                                    return Center(child: Text("Không có bài viết nào"));
                                  }
                                }
                                if(snapshot.hasError) {
                                  return Center(child: Text("Lỗi! Không thể load được vui lòng thử lại sau", style: TextStyle(color: Colors.red),));
                                }
                                return Center(child:CircularProgressIndicator());
                              }
                          )
                      ),
                    ),
                    Container(
                      width: 280,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("BÀI VIẾT MỚI NHẤT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          StreamBuilder(
                              stream: postBloc.postRightStream,
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  ResultCount<PostAggregation> resultRightCount = snapshot.data;
                                  if(!resultRightCount.resultList.isEmpty)
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: resultRightCount.resultList.map((e) {
                                        return RightItem(postAggregation: e);
                                      }).toList()
                                    );
                                  else {
                                    return Center(child: Text("Không có bài viết nào"));
                                  }
                                }
                                if(snapshot.hasError) {
                                  return Center(child: Text("Lỗi! Không thể load được vui lòng thử lại sau", style: TextStyle(color: Colors.red),));
                                }
                                return Center(child:CircularProgressIndicator());
                              }
                          )
                        ],
                      ),
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