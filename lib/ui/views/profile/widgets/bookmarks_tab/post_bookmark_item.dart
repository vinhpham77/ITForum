import 'package:cay_khe/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

import '../../../../../dtos/bookmark_item.dart';
import '../../../../common/utils/date_time.dart';
import '../../../../router.dart';

class PostBookmarkItem extends StatelessWidget {
  final PostBookmark postBookmark;

  const PostBookmarkItem({super.key, required this.postBookmark});

  @override
  Widget build(BuildContext context) {
    return _buildContainer();
  }

  Padding _buildContainer() {
    final TextStyle fieldCountStyle = TextStyle(
        fontSize: 13, color: Colors.grey[700]);
    final TextStyle timeStyle = TextStyle(
      fontSize: 13,
      color: Colors.grey[700],
      fontWeight: FontWeight.w300,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: postBookmark.user == null
                ? null
                : () => {
              appRouter.go(
                  '/profile/${postBookmark.user?.username}',
                  extra: {})
            },
            hoverColor: Colors.black12,
            child:
          ClipOval(
              child: UserAvatar(
                imageUrl: postBookmark.user?.avatarUrl,
                size: 54,
              )),),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: postBookmark.user == null
                          ? null
                          : () => {
                        appRouter.go(
                            '/profile/${postBookmark.user?.username}',
                            extra: {})
                      },
                      hoverColor: Colors.black12,
                      child:
                    Text(
                      postBookmark.user?.displayName ?? 'Người dùng ẩn danh',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.indigo[700]),
                    ),),
                    const SizedBox(width: 12),
                    buildIconField(Icons.auto_fix_high_outlined,
                        getTimeAgo(postBookmark.updatedAt), timeStyle)
                    ,
                    buildIconField(Icons.access_time_outlined,
                        getTimeAgo(postBookmark.bookmarkedAt), timeStyle)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: InkWell(
                    onTap: postBookmark.title == null
                        ? null
                        : () =>
                    {
                      appRouter.go('/posts/${postBookmark.id}', extra: {})
                    },
                    hoverColor: Colors.black12,
                    child: Text(
                      postBookmark.title ?? 'Bài viết không còn tồn tại',
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
                      for (var tag in postBookmark.tags)
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
                      if (postBookmark.tags.isNotEmpty) const SizedBox(width: 16),
                      buildIconField(
                          Icons.comment_outlined,
                          postBookmark.commentCount.toString(), fieldCountStyle),
                      buildIconField(
                          postBookmark.score < 0
                              ? Icons.trending_down_outlined
                              : Icons.trending_up_outlined,
                          postBookmark.score.toString(), fieldCountStyle),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ]
        ,
      )
      ,
    );
  }

  Widget buildIconField(IconData icon, String text, TextStyle textStyle) {
    if (text.isEmpty) {
      return Container();
    }

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
          Text(text,
              style: textStyle),
        ],
      ),
    );
  }
}
