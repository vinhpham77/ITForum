import 'dart:html';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class item {
  item({required this.name, required this.icon});

  final String name;
  final IconData icon;
}

class MoreHoriz extends StatefulWidget {
  const MoreHoriz({super.key, required this.type, required this.idContent});
  final String type;
  final String idContent;
  @override
  State<MoreHoriz> createState() => _MoreHorizState();
}

class _MoreHorizState extends State<MoreHoriz> {
  SeriesRepository seriesRepository=SeriesRepository();
  PostRepository postRepository=PostRepository();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widgetMoreHoriz()
      ],
    );
  }
  Widget widgetMoreHoriz() => Row(
        children: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
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
                  // Action for "Sửa" item
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
                  // Action for "Xóa bài viết" item
                },
                child:  Row(
                  children: [
                    const Icon(Icons.delete),
                    const SizedBox(width: 20),
                    Text("Xóa ${widget.type}"),
                  ],
                ),
              ),
              // Add more MenuItemButton widgets as needed
            ],
          ),
        ],
      );
  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("Xác nhận xóa ${widget.type}"),
          content:  Text("Bạn có chắc chắn muốn xóa ${widget.type} không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                deleteSeries(widget.idContent,widget.type);
                print("Xóa xong");
              },
              child: Text("Xóa"),
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteSeries(String id, String type) async {
    var future;
    if (type == 'bài viết') {
      // Gọi hàm xóa từ postRepository và chờ kết quả
      future = await postRepository.delete(id);
      appRouter.go("/");
      // Kiểm tra HttpStatus
      if (future.statusCode == HttpStatus.ok) {
        print('Xóa thành công!');
      } else {
        print('Lỗi khi xóa: ${future.statusCode}');
        // Xử lý lỗi khác nếu cần
      }
    } else {
      print('Loại không được hỗ trợ.');
      // Xử lý khi loại không được hỗ trợ nếu cần
    }
  }

}
