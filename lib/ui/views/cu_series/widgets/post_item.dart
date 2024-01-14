import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/date_time.dart';

class PostItem extends StatelessWidget {
  final PostAggregation postUser;
  final VoidCallback? onTap;

  const PostItem({super.key, required this.postUser, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: _buildContainer(),
      );
    } else {
      return _buildContainer();
    }
  }

  Widget _buildContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
              child: UserAvatar(
                imageUrl: postUser.user?.avatarUrl,
                size: 48,
              )),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      postUser.user!.displayName,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.indigo[700]),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getTimeAgo(postUser.updatedAt!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: Text(
                    postUser.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: onTap == null
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      for (var tag in postUser.tags)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                    ]),
                    Row(children: [
                      const SizedBox(width: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.comment_outlined,
                            size: 16,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 2),
                          Text('${postUser.commentCount}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            postUser.score < 0
                                ? Icons.trending_down_outlined
                                : Icons.trending_up_outlined,
                            size: 16,
                            color: Colors.black87,
                          ),
                          Text('${postUser.score}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black87)),
                        ],
                      )
                    ])
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
