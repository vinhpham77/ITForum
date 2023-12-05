import 'dart:async';

import 'package:cay_khe/repositories/post_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../models/post.dart';

class PostTabBloc {
  late BuildContext context;
  final _postTabController = StreamController<List<Post>>();
  PostRepository _postRepository = PostRepository();
  Stream<List<Post>> get postTabStream => _postTabController.stream;

  PostTabBloc({required this.context});
  void loadPost({required Map<String, String> params}) {
  //   var future = _postRepository.get(
  //       username: params['username'] ?? '',
  //       page: params['page'] ?? '1'
  //   );
  //   future.then((response) {
  //     resultCount = ResultCount.fromJson(response.data, PostAggregation.fromJson);
  //     _postController.sink.add(resultCount);
  //   }).catchError((error) {
  //     String message = getMessageFromException(error);
  //     showTopRightSnackBar(context, message, NotifyType.error);
  //     _postController.addError("");
  //   });
  }

  void dispose() {
    _postTabController.close();
  }
}