import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/post_aggregation.dart';

class RightItem extends StatelessWidget {
  final PostAggregation postAggregation;
  const RightItem({required this.postAggregation});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black38))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Text(postAggregation.title,
              style: TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                postAggregation.score < 0
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                size: 16,
                color: Colors.black87,
              ),
              Text('${postAggregation.score}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Text(postAggregation.user.displayName,
              style: TextStyle(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}