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
  final StreamController _postRightController = StreamController();

  Stream get postStream => _postController.stream;
  Stream get postRightStream => _postRightController.stream;

  late BuildContext context;

  PostAggregationRepository postAggregatioRepository = PostAggregationRepository();
  late ResultCount<PostAggregation> resultCount;
  late ResultCount<PostAggregation> resultRightCount;

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
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      _postController.addError("");
    });
  }

  void loadRightPost({required String fieldSearch, required String searchContent, int limit = 5}) {
    var future = postAggregatioRepository.getSearch(
        fieldSearch: fieldSearch,
        searchContent: searchContent,
        sort: 'DESC',
        sortField: 'updatedAt',
        page: '1',
        limit: limit
      );
    future.then((response) {
      resultRightCount = ResultCount.fromJson(response.data, PostAggregation.fromJson);
      _postRightController.sink.add(resultRightCount);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      _postRightController.addError("");
    });
  }

  void dispose() {
    _postController.close();
    _postRightController.close();
  }
}