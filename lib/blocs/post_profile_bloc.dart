
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:flutter/cupertino.dart';

import '../repositories/post_aggregation_repository.dart';

class PostBloc {
  // final StreamController _postController = StreamController();
  // final StreamController _postRightController = StreamController();

  // Stream get postStream => _postController.stream;
  // Stream get postRightStream => _postRightController.stream;

  late BuildContext context;

  PostRepository postRepository = PostRepository();

  // late ResultCount<PostAggregation> resultCount;
  // late ResultCount<PostAggregation> resultRightCount;

  PostBloc({required this.context});
}