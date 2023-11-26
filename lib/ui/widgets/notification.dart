import 'dart:async';

import 'package:flutter/material.dart';

import '../../dtos/notify_type.dart';

void showTopRightSnackBar(
    BuildContext context, String message, NotifyType notifyType) {
  Icon icon;
  Color backgroundColor;
  String title;

  switch (notifyType) {
    case NotifyType.success:
      backgroundColor = Colors.green;
      title = "Thành công";
      icon = const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 28.0,
      );
      break;
    case NotifyType.error:
      backgroundColor = Colors.red;
      title = "Lỗi";
      icon = const Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 28.0,
      );
      break;
    case NotifyType.info:
      backgroundColor = Colors.blue;
      title = "Thông tin";
      icon = const Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 28.0,
      );
      break;
    case NotifyType.warning:
      backgroundColor = Colors.orange;
      title = "Cảnh báo";
      icon = const Icon(
        Icons.warning_amber_outlined,
        color: Colors.white,
        size: 28.0,
      );
      break;
    default:
      backgroundColor = Colors.black38;
      title = "Thông báo";
      icon = const Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 28.0,
      );
      break;
  }

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 16.0,
      right: 16.0,
      child: Material(
        color: Colors.transparent,
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
          padding: const EdgeInsets.fromLTRB(0, 12.0, 16.0, 12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: icon,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2)).then((_) {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
