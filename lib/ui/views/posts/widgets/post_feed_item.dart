import 'package:cay_khe/models/post_aggregation.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/date_time.dart';
import '../../../router.dart';
import '../../../widgets/user_avatar.dart';

class PostFeedItem extends StatelessWidget {
  final PostAggregation postAggregation;

  const PostFeedItem({super.key, required this.postAggregation});

  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  Container _buildContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => appRouter
                .go('/profile/${postAggregation.user?.username}', extra: {}),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: UserAvatar(
                  imageUrl: postAggregation.user?.avatarUrl,
                  size: 54,
                )),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: postAggregation.user == null
                          ? null
                          : () => appRouter.go(
                              '/profile/${postAggregation.user!.username}',
                              extra: {}),
                      child: Text(
                        postAggregation.user?.displayName ??
                            'Người dùng ẩn danh',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.indigo[700]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getTimeAgo(postAggregation.updatedAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: InkWell(
                    onTap: postAggregation.title == null ? null : () => {
                      appRouter.go('/posts/${postAggregation.id}', extra: {})
                    },
                    hoverColor: Colors.black12,
                    child: Text(
                      postAggregation.title ?? 'Bài viết không còn tồn tại',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Row(children: [
                      for (var tag in postAggregation.tags)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      buildFieldCount(
                          Icons.comment_outlined, postAggregation.commentCount),
                      buildFieldCount(
                          postAggregation.score < 0
                              ? Icons.trending_down_outlined
                              : Icons.trending_up_outlined,
                          postAggregation.score),
                    ]),
                  ],
                ),
              ],
            ),
          )
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
