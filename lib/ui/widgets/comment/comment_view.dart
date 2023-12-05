import 'dart:core';

import 'package:cay_khe/dtos/comment.dart';
import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/dtos/sub_comment_aggregate.dart';
import 'package:cay_khe/repositories/comment_repository.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/widgets/comment/create_comment_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api_config.dart';
import '../../../dtos/notify_type.dart';
import '../../../dtos/sub_comment_dto.dart';
import '../../../models/user.dart';
import '../../../repositories/image_repository.dart';
import '../../common/utils/date_time.dart';
import '../../common/utils/message_from_exception.dart';
import '../notification.dart';
import '../user_avatar.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.postId});
  final String postId;

  @override
  State<CommentView> createState() => _CommentState();
}

class _CommentState extends State<CommentView> {
  final CommentRepository _commentRepository = CommentRepository();
  List<Comment> _comments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComment(subId: '');
  }

  void upComment(SubCommentAggreGate subCommentAggreGate) {
    setState(() {
      _comments.insert(0, Comment(subCommentAggreGate: subCommentAggreGate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bình luận", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: JwtPayload.sub == null ? Center(
                  child: Text("Đăng nhập để bình luận", style: TextStyle(color: Colors.black38),),
                ) : CreateCommentView(postId: widget.postId, callback: upComment),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: listSubCommentView(paddingLeft: 0, comments: _comments),
              )
            ],
          ),
        );
      },
    );
  }

  Future getComment({String subId = ''}) async {
    var future = _commentRepository.getSubComment(widget.postId,subId);
    future.then((response) {
      _comments = response == null ? [] : response.data.map<Comment>((e) => Comment(subCommentAggreGate: SubCommentAggreGate.fromJson(e))).toList();
      setState(() {});
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Widget listSubCommentView({required double paddingLeft, required List<Comment> comments}){
    return Container(
      padding: EdgeInsets.only(left: paddingLeft),
      child: Column(
        children: comments.map((e) {
          return subCommentView(comment: e, comments: comments);
        }).toList()
      ),
    );
  }

  Widget subCommentView({required Comment comment, required List<Comment> comments}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerComment(comment.subCommentAggreGate.user, comment.subCommentAggreGate.updatedAt),
          comment.isEdit ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => {
                  _showConfirmCancel(context, comment, () {
                    comment.isEdit = false;
                  })
                },
              ),
              CreateCommentView(postId: widget.postId,
                  subId: comment.subCommentAggreGate.id,
                  callback: (SubCommentAggreGate subCom) {
                    setState(() {
                      comment.subCommentAggreGate = subCom;
                      comment.isEdit = false;
                    });
                  },
                  context: comment.subCommentAggreGate.content,)
            ],
          ) : contentComment(content: comment.subCommentAggreGate.content),
          Container(
            padding: EdgeInsets.only(left: 24),
            child: comment.isEdit ? Container() : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if(JwtPayload.sub == null) {
                      appRouter.go('/login');
                      return;
                    }
                    setState(() {
                      if(!comment.isReply) comment.isReply = true;
                    });
                  },
                  child: Text("Trả lời", style: TextStyle(color: Colors.blueAccent),),
                ),
                SizedBox(width: 12,),
                menuComment(username: comment.subCommentAggreGate.username, comment: comment, comments: comments),
              ],
            ),
          ),

          comment.isReply ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => {
                  _showConfirmCancel(context, comment, () {
                    comment.isReply = false;
                  })
                },
              ),
              CreateCommentView(postId: widget.postId,
                  subId: comment.subCommentAggreGate.id,
                  callback: (SubCommentAggreGate subCom) {
                    setState(() {
                      comment.comments.insert(0, Comment(subCommentAggreGate: subCom));
                      comment.isReply = false;
                    });
                  })
            ],
          ) : Container(),
          SizedBox(width: 16,),
          comment.comments.isEmpty ? Container() : listSubCommentView(paddingLeft: 24, comments: comment.comments),
          Container(
            padding: EdgeInsets.only(left: 32),
            child: (comment.subCommentAggreGate.right > comment.subCommentAggreGate.left+1 && !comment.isShowChildren) ?
              InkWell(
                onTap: () {
                  Future<Response<dynamic>> future = _commentRepository.getSubComment(widget.postId, comment.subCommentAggreGate.id);
                  future.then((response) {
                    comment.comments = response == null ? [] : response.data.map<Comment>((e) => Comment(subCommentAggreGate: SubCommentAggreGate.fromJson(e))).toList();
                    comment.isShowChildren = true;
                    setState(() {});
                  }).catchError((error) {
                    String message = getMessageFromException(error);
                    showTopRightSnackBar(context, message, NotifyType.error);
                  });
                  },
                child: Text("Xem thêm", style: TextStyle(color: Colors.blueAccent),),
              ) : Container(),
          ),
          Padding(padding: EdgeInsets.only(bottom: 16))
        ],
      ),
    );
  }

  Widget headerComment(User user, DateTime updatedAt) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8, bottom: 8),
          child: InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child:UserAvatar(imageUrl: user.avatarUrl, size: 32,),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(user.displayName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                ),
                SizedBox(width: 8,),
                Text("@${user.username}", style: TextStyle(fontSize: 12, color: Colors.black38),),
              ],
            ),
            Text(
              getTimeAgo(updatedAt),
              style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),)
          ],
        )
      ],
    );
  }

  Widget contentComment({required String content}) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 4, left: 20, right: 20),
      child: Markdown(
        data: content,
        styleSheet:
        MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          textScaleFactor: 1.4,
          h1: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 32),
          h2: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 28),
          h3: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 20),
          h6: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 13),
          p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
          blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey.shade700,
          ),
          // Custom blockquote style
          listBullet: const TextStyle(
              fontSize: 16), // Custom list item bullet style
        ),
        softLineBreak: true,
        shrinkWrap: true,
      ),
    );
  }
  
  Widget menuComment({required String username, required Comment comment, required List<Comment> comments}) {
    return MenuAnchor(
      builder: (BuildContext context, MenuController controller,
          Widget? child) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: const Icon(Icons.more_horiz),
        );
      },
      menuChildren: username == JwtPayload.sub ? menuSignIn(comments, comment) :
          [
            MenuItemButton(
                onPressed: () =>
                {},
                child: Row(
                  children: [
                    Icon(Icons.report),
                    const SizedBox(
                      width: 20,
                    ),
                    Text('Báo cáo')
                  ],
                )
            ),
          ]
    );
  }

  List<Widget> menuSignIn(List<Comment> comments, Comment comment) {
    return <Widget>[
      MenuItemButton(
          onPressed: () {
            setState(() {
              if(!comment.isEdit)
                comment.isEdit = true;
            });
          },
          child: Row(
            children: [
              Icon(Icons.edit),
              const SizedBox(
                width: 20,
              ),
              Text('Sửa')
            ],
          )
      ),
      MenuItemButton(
          onPressed: () {
            _showConfirmationDialog(context, comments, comment.subCommentAggreGate.id);
          },
          child: Row(
            children: [
              Icon(Icons.delete),
              const SizedBox(
                width: 20,
              ),
              Text('Xóa')
            ],
          )
      )
    ];
  }

   _showConfirmationDialog(BuildContext context, List<Comment> comments, String subId) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn xóa bình luận này và các câu trả lời của bình luận này?'),
          actions: <Widget>[
            Container(
              height: 40,
              child: FloatingActionButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: 40,
              width: 100,
              child: FloatingActionButton(
                child: Text('Chấp nhận', softWrap: false,),
                onPressed: () {
                  var future = _commentRepository.deleteSubComment(widget.postId, subId);
                  future.then((response) {
                    bool result = response.data;
                    if(!result)
                      return;
                    int index = comments.indexWhere((item) => item.subCommentAggreGate.id == subId);
                    if(index == -1)
                      return;
                    setState(() {comments.removeAt(index);});
                  }).catchError((error) {
                    String message = getMessageFromException(error);
                    showTopRightSnackBar(context, message, NotifyType.error);
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    ); // Thêm '?? false' ở đây
  }

  _showConfirmCancel(BuildContext context, Comment comment, Function() callback) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn hủy?'),
          actions: <Widget>[
            Container(
              height: 40,
              child: FloatingActionButton(
                child: Text('Hủy'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: 40,
              width: 100,
              child: FloatingActionButton(
                child: Text('Chấp nhận', softWrap: false),
                onPressed: () {
                  setState(() {
                    callback();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    ); // Thêm '?? false' ở đây
  }

}
