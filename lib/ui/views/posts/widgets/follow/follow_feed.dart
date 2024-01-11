import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../router.dart';
import 'follow_post.dart';
import 'follow_series.dart';

class FollowFeed extends StatefulWidget {
  final int page;
  final int limit;
  final Map<String, String> params;

  const FollowFeed(
      {super.key,
        required this.page,
        required this.limit,
        required this.params
      });
  @override
  State<FollowFeed> createState() => _FollowFeedState();
}

class _FollowFeedState extends State<FollowFeed> {
  String param = "";
  @override
  Widget build(BuildContext context) {
    String isSeriesStr = widget.params['isSeries'] ?? 'false';
    bool isSeries = false;
    if(isSeriesStr == 'true')
      isSeries = true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
            children: [
              const Text("Loại:"),
              SizedBox(width: 16,),
              DropdownButtonHideUnderline(
                child:  DropdownButton<String>(
                  value: isSeries ? 'Series' : 'Bài viết',
                  onChanged: (String? newValue) {
                    param = isSeries ? 'false' : 'true';
                    appRouter.go('/viewfollow/isSeries=${param}');
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
        isSeries ? FollowSeries(page: widget.page, limit: widget.limit, params: widget.params) :
        FollowPost(page: widget.page, limit: widget.limit, isQuestion: false, params: widget.params)
      ],
    );
  }
}