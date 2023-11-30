import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl ?? '',
      width: size,
      height: size,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Icon(Icons.account_circle_rounded,
            size: size, color: Colors.black54);
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.account_circle_rounded,
            size: size, color: Colors.black54);
      },
    );
  }
}
