import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/user_profile/widgets/post_tab_item.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../dtos/jwt_payload.dart';
import '../../../../dtos/pagination_states.dart';
import '../../../common/utils/message_from_exception.dart';
import '../../../widgets/pagination2.dart';

class PostsTab extends StatefulWidget {
  final String username;
  final int page;
  final int limit;
  final bool isQuestion;

  const PostsTab(
      {super.key,
      required this.username,
      required this.page,
      required this.limit,
      required this.isQuestion});

  @override
  State<PostsTab> createState() => _TabPageState();
}

class _TabPageState extends State<PostsTab> {
  late Future<Response<dynamic>> futureData;
  final PostRepository _postRepository = PostRepository();
  bool isAuthorized = false;
  late ResultCount<PostAggregation> postUsers;
  late String objectName;
  late String object;

  @override
  void initState() {
    super.initState();
    objectName = widget.isQuestion ? "câu hỏi" : "bài viết";
    object = widget.isQuestion ? "questions" : "posts";
    isAuthorized = JwtPayload.sub == widget.username;
    futureData = _postRepository.getByUser(widget.username,
        page: widget.page, limit: widget.limit, isQuestion: widget.isQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          postUsers = ResultCount.fromJson(
              snapshot.data?.data, PostAggregation.fromJson);
          if (postUsers.resultList.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              child: Text("Không có $objectName nào!",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            );
          } else {
            return Column(
              children: [
                buildPostList(),
                buildPagination(),
              ],
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Có lỗi xảy ra. Vui lòng thử lại sau!"),
          );
        }
        return Center(
            child: Container(
                padding: const EdgeInsets.only(top: 40),
                child: const CircularProgressIndicator()));
      },
    );
  }

  Pagination2 buildPagination() {
    return Pagination2(
        pagingStates: PaginationStates(
            count: postUsers.count,
            limit: widget.limit,
            currentPage: widget.page,
            range: 2,
            path: "/profile/${widget.username}/$object",
            params: {}));
  }

  Padding buildPostList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Column(
        children: [
          for (var postUser in postUsers.resultList) buildOneRow(postUser),
        ],
      ),
    );
  }

  Row buildOneRow(PostAggregation postUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            transform: Matrix4.translationValues(-8.0, 0, 0),
            child: PostTabItem(postUser: postUser),
          ),
        ),
        if (isAuthorized)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent[400],
                side: BorderSide(color: Colors.redAccent[400]!, width: 1),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                textStyle: const TextStyle(fontSize: 13)),
            onPressed: () => showDeleteConfirmationDialog(context, postUser),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, size: 16),
                SizedBox(width: 4),
                Text("Xoá")
              ],
            ),
          ),
      ],
    );
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, PostAggregation postUser) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Bạn có chắc chắn muốn xoá $objectName "${postUser.title}" không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () {
                Navigator.of(context).pop();
                deletePost(postUser);
              },
            ),
          ],
        );
      },
    );
  }

  void deletePost(PostAggregation postUser) {
    _postRepository.delete(postUser.id!).then((value) {
      showTopRightSnackBar(context, "Xoá $object ${postUser.title} thành công!",
          NotifyType.success);
      setState(() {
        postUsers.resultList.remove(postUser);
        appRouter.refresh();
      });
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
