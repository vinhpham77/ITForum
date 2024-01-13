import 'dart:html';
import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';

class MoreHoriz extends StatefulWidget {
  final String username;
  final String authorname;
  final String type;
  final String idContent;

  const MoreHoriz(
      {super.key,
      required this.type,
      required this.idContent,
      required this.username,
      required this.authorname});

  @override
  State<MoreHoriz> createState() => _MoreHorizState();
}

class _MoreHorizState extends State<MoreHoriz> {
  SeriesRepository seriesRepository = SeriesRepository();
  PostRepository postRepository = PostRepository();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [widgetMoreHoriz()],
    );
  }

  Widget widgetMoreHoriz() => Row(
        children: [
          if (widget.username == widget.authorname)
            _myMenuAnchor()
          else
            _menuAnchor()
        ],
      );

  Widget _myMenuAnchor() {
    print("mymenu");
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz),
          iconSize: 24,
          splashRadius: 16,
          tooltip: 'Thêm hành động',
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            if (widget.type == "series") {
              appRouter.go("/series/${widget.idContent}/edit");
            } else {
              appRouter.go("/posts/${widget.idContent}/edit");
            }
          },
          child: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 20),
              Text("Sửa"),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () {
            showDeleteConfirmationDialog(context);
          },
          child: Row(
            children: [
              const Icon(Icons.delete),
              const SizedBox(width: 20),
              Text("Xóa ${widget.type}"),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () {
            if (widget.username == '') {
              appRouter.go("/login");
              return;
            }
            if (widget.username != widget.authorname) {
              showTopRightSnackBar(context, "${widget.type} đã được báo cáo",
                  NotifyType.success);
            } else {
              showTopRightSnackBar(
                  context,
                  "Bạn không thể báo cáo ${widget.type} của mình",
                  NotifyType.success);
            }
          },
          child: const Row(
            children: [
              Icon(Icons.flag),
              SizedBox(width: 20),
              Text("Báo cáo"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuAnchor() {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz),
          iconSize: 24,
          splashRadius: 16,
          tooltip: 'Thêm hành động',
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            if (widget.username == '') {
              appRouter.go("/login");
              return;
            }
            if (widget.username != widget.authorname) {
              showTopRightSnackBar(context, "${widget.type} đã được báo cáo",
                  NotifyType.success);
            } else {
              showTopRightSnackBar(
                  context,
                  "Bạn không thể báo cáo ${widget.type} của mình",
                  NotifyType.success);
            }
          },
          child: const Row(
            children: [
              Icon(Icons.flag),
              SizedBox(width: 20),
              Text("Báo cáo"),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa ${widget.type}"),
          content: Text("Bạn có chắc chắn muốn xóa ${widget.type} không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                deleteSeries(widget.idContent, widget.type);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showAddPostConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Bạn muốn thêm bài viết này vào series nào"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                deleteSeries(widget.idContent, widget.type);
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSeries(String id, String type) async {
    Response future;
    if (type == 'bài viết') {
      future = await postRepository.delete(id);
      if (future.statusCode == HttpStatus.ok) {
        appRouter.go("/");
      } else {
        print('Lỗi khi xóa: ${future.statusCode}');
      }
    } else {
      if (type == 'series') {
        future = await seriesRepository.delete(id);
        if (future.statusCode == HttpStatus.ok) {
          appRouter.go("/");
        } else {
          print('Lỗi khi xóa: ${future.statusCode}');
        }
      }
    }
  }
}
