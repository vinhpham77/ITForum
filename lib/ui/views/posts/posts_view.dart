import 'package:cay_khe/blocs/post_bloc.dart';
import 'package:cay_khe/dtos/limit_page.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/ui/views/posts/widgets/left_menu.dart';
import 'package:cay_khe/ui/views/posts/widgets/right_item.dart';
import 'package:cay_khe/ui/widgets/pagination.dart';
import 'package:cay_khe/ui/widgets/post_feed_item.dart';
import 'package:flutter/material.dart';

import 'package:cay_khe/models/post_aggregation.dart';

import '../../common/app_constants.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key, this.indexSelected = 0, required this.params});

  final Map<String, String> params;
  final int indexSelected;

  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int page = int.parse(widget.params['page'] ?? "1");
    listSelectBtn[widget.indexSelected].isSelected = true;
    postBloc = PostBloc(context: context);
    postBloc.loadPost(params: widget.params);
    postBloc.loadRightPost(fieldSearch: 'tags', searchContent: 'HoiDap');
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
          child: Center(
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
                        child: page < 1
                            ? const Center(
                                child: Text(
                                "Lỗi! Page không thể nhỏ hơn 1",
                                style: TextStyle(color: Colors.red),
                              ))
                            : StreamBuilder(
                                stream: postBloc.postStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    ResultCount<PostAggregation> resultCount =
                                        snapshot.data;
                                    if (resultCount.resultList.isNotEmpty) {
                                      return Column(
                                        children: [
                                          Column(
                                              children: resultCount.resultList
                                                  .map((e) {
                                            return PostFeedItem(
                                                postAggregation: e);
                                          }).toList()),
                                          Pagination(
                                            path: "/viewposts",
                                            totalItem: resultCount.count,
                                            params: widget.params,
                                            selectedPage: page,
                                          )
                                        ],
                                      );
                                    } else {
                                      int totalPasge =
                                          (resultCount.count / limitPage)
                                              .ceil();

                                      if (page > totalPasge) {
                                        return Center(
                                            child: Text(
                                          "Lỗi! Tổng số trang là $totalPasge, không thể truy cập trang $page",
                                          style: TextStyle(color: Colors.red),
                                        ));
                                      }
                                      return const Center(
                                          child: Text("Không có bài viết nào"));
                                    }
                                  }
                                  if (snapshot.hasError) {
                                    return const Center(
                                        child: Text(
                                      "Lỗi! Không thể load được vui lòng thử lại sau",
                                      style: TextStyle(color: Colors.red),
                                    ));
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                })),
                  ),
                  SizedBox(
                    width: 280,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CÂU HỎI MỚI NHẤT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        StreamBuilder(
                            stream: postBloc.postRightStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                ResultCount<PostAggregation> resultRightCount =
                                    snapshot.data;
                                if (resultRightCount.resultList.isNotEmpty) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          resultRightCount.resultList.map((e) {
                                        return RightItem(postAggregation: e);
                                      }).toList());
                                } else {
                                  return const Center(
                                      child: Text("Không có câu hỏi nào"));
                                }
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text(
                                  "Lỗi! Không thể load được vui lòng thử lại sau",
                                  style: TextStyle(color: Colors.red),
                                ));
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            })
                      ],
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
}

class NavigationPost {
  final int index;
  String text;
  bool isSelected;
  String route;

  NavigationPost(
      {required this.index,
      this.text = "",
      this.isSelected = false,
      this.route = ""});
}
