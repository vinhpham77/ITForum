import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../dtos/notify_type.dart';
import '../models/post_aggregation.dart';
import '../models/result_count.dart';
import '../repositories/post_aggregation_repository.dart';
import '../ui/common/utils/message_from_exception.dart';
import '../ui/widgets/notification.dart';

class PostBloc {
  final StreamController _postController = StreamController();

  Stream get postStream => _postController.stream;

  late BuildContext context;

  PostAggregatioRepository postAggregatioRepository = PostAggregatioRepository();
  late ResultCount<PostAggregation> resultCount;

  PostBloc({required this.context});

  void loadPost({required Map<String, String> params}) {
    var future = postAggregatioRepository.getSearch(
        fieldSearch: params['fieldSearch'] ?? '',
        searchContent: params['searchContent'] ?? '',
        sort: params['sort'] ?? 'DESC',
        sortField: params['sortField'] ?? 'updatedAt',
        page: params['page'] ?? '1');
    future.then((response) {
      resultCount = ResultCount.fromJson(response.data, PostAggregation.fromJson);
      _postController.sink.add(resultCount);
      // print(resultCount);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      _postController.addError("");
    });
  }

  void dispose() {
    _postController.close();
  }
}