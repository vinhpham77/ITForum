import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/repositories/post_aggregation_repository.dart';
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
  const PostsView({super.key, this.indexSelected = 0, required this.queryParams});
  final Map<String, String> queryParams;
  final int indexSelected;
  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  final PostAggregatioRepository postAggregatioRepository = PostAggregatioRepository();
  late ResultCount<PostAggregation> resultCount = ResultCount(resultList: [], count: 0);
  List<NavigationPost> listSelectBtn = [
    NavigationPost(index: 0, text: "Mới nhất"),
    NavigationPost(index: 1, text: "Đang theo dõi"),
    NavigationPost(index: 2, text: "Series"),
    NavigationPost(index: 3, text: "Bookmark của tôi")
  ];
  @override
  Widget build(BuildContext context) {

    _loadResult();
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
                        child: Container(
                          child: resultCount.resultList.isEmpty ?
                            const Center(child:CircularProgressIndicator()) : Column(
                            children: [
                              Column(
                                  children:resultCount.resultList.map((e) {
                                    return PostFeedItem(postAggregation: e);
                                  }).toList()
                              ),
                              Pagination(routeStr: "", totalItem: resultCount.count)
                            ],
                          ),
                        ),
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

  void _loadResult() {
    var future = postAggregatioRepository.getSearch(
      fieldSearch: widget.queryParams['fieldSearch'] ?? '',
      searchContent: widget.queryParams['searchContent'] ?? '',
      sort: widget.queryParams['sort'] ?? '',
      sortField: widget.queryParams['sortField'] ?? '',
      page: widget.queryParams['page'] ?? '1');
    future.then((response) {
      resultCount = ResultCount.fromJson(response.data, PostAggregation.fromJson);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }
}

class NavigationPost {
  final int index;
  String text;
  bool isSelected;
  String route;
  NavigationPost({required this.index,this.text = "", this.isSelected = false, this.route = ""});
}