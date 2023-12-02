import 'package:cay_khe/models/post_aggregation.dart';
import 'package:flutter/material.dart';

import '../common/utils/date_time.dart';

class PostFeedItem extends StatelessWidget {
  final PostAggregation postAggregation;
  const PostFeedItem({super.key, required this.postAggregation});
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _buildPostImage(postAggregation.user.avatarUrl ?? ""),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              postAggregation.user.displayName,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            getTimeAgo(postAggregation.updatedAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 4),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            postAggregation.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            softWrap: true,
                          ),
                        )

                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            for (var tag in postAggregation.tags)
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
                                postAggregation.score < 0
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                size: 16,
                                color: Colors.black87,
                              ),
                              Text('${postAggregation.score}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
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

  Widget tagBtn(String text) {
    return TextButton(
      onPressed: (){},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(244, 244, 245, 1)),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Color.fromRGBO(233, 233, 235, 1), // your color here
            width: 1,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // your radius here
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(4), // your padding value here
        ),
      ),
      child: Text(text, style: const TextStyle(color: Color.fromRGBO(144, 147, 153, 1), fontSize: 12),),
    );
  }
  Widget _buildPostImage(String avatarUrl) {
    return Image.network(
      avatarUrl,
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
    }
}