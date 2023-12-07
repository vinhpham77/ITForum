import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

import '../../../../common/utils/date_time.dart';
import '../../../../router.dart';

class PostTabItem extends StatelessWidget {
  final PostAggregation postUser;

  const PostTabItem({super.key, required this.postUser});

  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  Padding _buildContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: UserAvatar(
                imageUrl: postUser.user.avatarUrl,
                size: 54,
              )),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    JwtPayload.displayName!,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.indigo[700]),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    getTimeAgo(postUser.updatedAt),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 4),
                child: InkWell(
                  onTap: () =>
                      appRouter.push('/posts/${postUser.id}', extra: {}),
                  hoverColor: Colors.black12,
                  child: Text(
                    postUser.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Row(children: [
                    for (var tag in postUser.tags)
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
                    buildFieldCount(Icons.comment_outlined, postUser.commentCount),
                    buildFieldCount(postUser.score < 0
                        ? Icons.trending_down_outlined
                        : Icons.trending_up_outlined, postUser.score),
                  ]),
                ],
              ),
            ],
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
          Text('$count', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
