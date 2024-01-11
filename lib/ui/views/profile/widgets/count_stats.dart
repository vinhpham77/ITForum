import 'package:cay_khe/dtos/profile_stats.dart';
import 'package:flutter/material.dart';

class CountStats extends StatelessWidget {
  final ProfileStats profileStats;

  const CountStats({super.key, required this.profileStats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 12,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Column(
        children: [
          _buildCountRow('Bài viết', profileStats.postCount),
          _buildCountRow('Câu hỏi', profileStats.questionCount),
          _buildCountRow('Series', profileStats.seriesCount),
          _buildCountRow('Đang theo dõi', profileStats.followingCount),
          _buildCountRow('Người theo dõi', profileStats.followerCount),
        ],
      ),
    );
  }

  Widget _buildCountRow(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}