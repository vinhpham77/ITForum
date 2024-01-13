import 'package:flutter/material.dart';

class TagListWidget extends StatelessWidget {
  final List<String> tags;

  const TagListWidget({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) => buildTagButton(tag)).toList(),
      ),
    );
  }

  Widget buildTagButton(String tag) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ElevatedButton(
        onPressed: () {
        },
        child: Text("#$tag"),
      ),
    );

  }
}