import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../models/post_aggregation.dart';
import '../../../../router.dart';

class RightItem extends StatelessWidget {
  final PostAggregation postAggregation;
  const RightItem({super.key, required this.postAggregation});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black38))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => {appRouter.go('/posts/${postAggregation.id}', extra: {})},
            child: Text(postAggregation.title,
              style: TextStyle(fontSize: 16),
            onTap: () => appRouter.push('/posts/${postAggregation.user?.id}', extra: {}),
            child: Text(postAggregation.title!,
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildFieldCount(Icons.comment_outlined, postAggregation.commentCount),
              buildFieldCount(
                  postAggregation.score < 0
                      ? Icons.trending_down_outlined
                      : Icons.trending_up_outlined,
                  postAggregation.score),
            ],
          ),
          InkWell(
            onTap: () => appRouter.go('/profile/${postAggregation.user.username}', extra: {}),
            child: Text(postAggregation.user.displayName,
              style: TextStyle(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }

  buildFieldCount(IconData icon, int count) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 2),
          Text('$count',
              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }
}