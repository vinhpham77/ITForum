import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl ?? '',
      width: radius,
      height: radius,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Icon(Icons.account_circle_rounded,
            size: radius, color: Colors.black54);
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.account_circle_rounded,
            size: radius, color: Colors.black54);
      },
    );
  }
}
