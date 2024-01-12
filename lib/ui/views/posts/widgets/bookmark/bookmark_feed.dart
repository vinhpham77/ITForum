import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/posts/posts_view.dart';
import 'package:cay_khe/ui/views/posts/widgets/bookmark/bookmark_post.dart';
import 'package:cay_khe/ui/views/posts/widgets/bookmark/bookmark_series.dart';
import 'package:flutter/material.dart';

class BookmarkFeed extends StatefulWidget {
  final String? username;
  final int page;
  final int limit;
  final bool isQuestion;
  final Map<String, String> params;

  const BookmarkFeed(
      {super.key,
        required this.username,
        required this.page,
        required this.limit,
        required this.isQuestion,
        required this.params
      });
  @override
  State<BookmarkFeed> createState() => _BookmarkFeedState();
}

class _BookmarkFeedState extends State<BookmarkFeed> {
  @override
  Widget build(BuildContext context) {
    String isSeriesStr = widget.params['isSeries'] ?? 'false';
    bool isSeries = false;
    if(isSeriesStr == 'true') {
      isSeries = true;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Sắp xếp theo:"),
            const SizedBox(width: 16),
            DropdownButtonHideUnderline(
              child:  DropdownButton<String>(
                value: isSeries ? 'Series' : 'Bài viết',
                onChanged: (String? newValue) {
                  widget.params["isSeries"] = isSeries ? 'false' : 'true';
                  appRouter.go('/viewbookmark/${converPageParams(widget.params)}');
                },
                items: <String>['Bài viết', 'Series']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ]
        ),
        isSeries ? BookmarkSeries(username: widget.username, page: widget.page, limit: widget.limit, params: widget.params) :
            BookmarkPost(username: widget.username, page: widget.page, limit: widget.limit, isQuestion: false, params: widget.params)
      ],
    );
  }
}