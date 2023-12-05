import 'package:cay_khe/dtos/sub_comment_aggregate.dart';

class Comment {
  SubCommentAggreGate subCommentAggreGate;
  List<Comment> comments;
  bool isReply;
  bool isShowChildren;
  bool isEdit;

  Comment({required this.subCommentAggreGate, List<Comment>? comments, this.isReply = false, this.isShowChildren = false, this.isEdit = false})
      : comments = comments ?? [];

}