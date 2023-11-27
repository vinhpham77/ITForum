import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:flutter/material.dart';

import '../../../../models/post.dart';
import '../../../common/utils/date_time.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostItem({super.key, required this.post, this.onTap});

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

  Container _buildContainer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: _buildPostImage(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      JwtPayload.displayName ?? post.createdBy,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getTimeAgo(post.updatedAt),
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
                    post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: onTap == null ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      for (var tag in post.tags)
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          post.score < 0
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          size: 16,
                          color: Colors.black87,
                        ),
                        Text('${post.score}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    if (JwtPayload.avatarUrl != null) {
      return Image.network(
        JwtPayload.avatarUrl!,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Icon(Icons.account_circle_rounded, size: 48, color: Colors.black54);
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.account_circle_rounded, size: 48, color: Colors.black54);
        },
      );
    } else {
      return const Icon(Icons.account_circle_rounded, size: 48, color: Colors.black54);
    }
  }
}
