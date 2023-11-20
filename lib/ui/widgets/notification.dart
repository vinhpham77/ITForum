import 'dart:async';

import 'package:flutter/material.dart';

import '../../dtos/notify_type.dart'; // Thêm dòng này để sử dụng Completer

void showTopRightSnackBar(
    BuildContext context, String message, NotifyType notifyType) {
  Color backgroundColor;
  String title;
  switch (notifyType) {
    case NotifyType.success:
      backgroundColor = Colors.green;
      title = "Thành công";
      break;
    case NotifyType.error:
      backgroundColor = Colors.red;
      title = "Lỗi";
      break;
    case NotifyType.info:
      backgroundColor = Colors.blue;
      title = "Thông tin";
      break;
    case NotifyType.warning:
      backgroundColor = Colors.orange;
      title = "Cảnh báo";
      break;
    default:
      backgroundColor = Colors.black38;
      title = "Thông báo";
      break;
  }

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 16.0,
      right: 16.0,
      child: Material(
        child: Container(
          constraints: const BoxConstraints(minWidth: 300.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4.0,
              )
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  // Tự động ẩn SnackBar sau 2 giây
  Future.delayed(const Duration(seconds: 2)).then((_) {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
