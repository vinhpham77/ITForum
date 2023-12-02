import 'package:flutter/material.dart';

class CustomTagItem extends StatelessWidget {
  final String tagName;
  final VoidCallback onDelete;

  const   CustomTagItem({
    super.key,
    required this.tagName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('#', style: TextStyle(fontSize: 16)),
            Text(tagName, style: const TextStyle(fontSize: 16, color: Colors.black87), maxLines: 1),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDelete,
              iconSize: 20,
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all(Colors.black54),
              )
            ),
          ],
        ),
      ),
    );
  }
}