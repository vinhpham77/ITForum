import 'package:flutter/cupertino.dart';

class TableOfContents extends StatelessWidget {
  final List<String> headings;
  final ScrollController scrollController;

  const TableOfContents({super.key, required this.headings, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var heading in headings) ...[
          GestureDetector(
            onTap: () {

              int index = headings.indexOf(heading);
              scrollController.animateTo(
                index * 100.0, // Giả sử mỗi tiêu đề tương ứng với 100 pixel
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            },
            child: Text(
              heading,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ],
    );
  }
}
