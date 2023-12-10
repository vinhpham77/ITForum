import 'package:cay_khe/dtos/series_user.dart';
import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

import '../../../../common/utils/date_time.dart';
import '../../../../router.dart';

class SeriesTabItem extends StatelessWidget {
  final SeriesUser seriesUser;

  const SeriesTabItem({super.key, required this.seriesUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: UserAvatar(
                imageUrl: seriesUser.user.avatarUrl,
                size: 54,
              )),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    seriesUser.user.displayName,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.indigo[700]),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    getTimeAgo(seriesUser.updatedAt),
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
                      appRouter.go('/series/${seriesUser.id}', extra: {}),
                  hoverColor: Colors.black12,
                  child: Text(
                    seriesUser.title,
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
                  buildFieldCount(
                      Icons.backup_table_rounded, seriesUser.postIds.length),
                  buildFieldCount(
                      Icons.comment_outlined, seriesUser.commentCount),
                  buildFieldCount(
                      seriesUser.score < 0
                          ? Icons.trending_down_outlined
                          : Icons.trending_up_outlined,
                      seriesUser.score)
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
