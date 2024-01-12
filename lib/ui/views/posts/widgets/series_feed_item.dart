import 'package:cay_khe/dtos/series_user.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/date_time.dart';
import '../../../router.dart';
import '../../../widgets/user_avatar.dart';

class SeriesFeedItem extends StatelessWidget {
  final SeriesUser seriesPost;

  const SeriesFeedItem({super.key, required this.seriesPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => appRouter
                .go('/profile/${seriesPost.user?.username}', extra: {}),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: UserAvatar(
                  imageUrl: seriesPost.user?.avatarUrl,
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
                      onTap: seriesPost.user == null
                          ? null
                          : () => appRouter.go(
                              '/profile/${seriesPost.user?.username}',
                              extra: {}),
                      child: Text(
                        seriesPost.user?.displayName ?? 'Người dùng ẩn danh',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.indigo[700]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      getTimeAgo(seriesPost.updatedAt),
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
                    onTap: seriesPost.title == null
                        ? null
                        : () =>
                            appRouter.go('/series/${seriesPost.id}', extra: {}),
                    hoverColor: Colors.black12,
                    child: Text(
                      seriesPost.title ?? 'Series không còn tồn tại',
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
                    buildFieldCount(
                        Icons.backup_table_rounded, seriesPost.postIds.length),
                    buildFieldCount(
                        Icons.comment_outlined, seriesPost.commentCount),
                    buildFieldCount(
                        seriesPost.score < 0
                            ? Icons.trending_down_outlined
                            : Icons.trending_up_outlined,
                        seriesPost.score)
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
      margin: const EdgeInsets.only(right: 8),
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
