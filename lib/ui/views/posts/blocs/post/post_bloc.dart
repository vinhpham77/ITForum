import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/post_aggregation_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostAggregationRepository _postAggregatioRepository = PostAggregationRepository();

  PostBloc() : super(PostsInitialState()) {
    on<LoadPostsEvent>(_loadPosts);
  }

  Future<void> _loadPosts(LoadPostsEvent event, Emitter<PostState> emit) async {
    try {
      print('chay');
      Response<dynamic> response = await _postAggregatioRepository.get(
        page: event.page,
        limit: event.limit,
        isQuestion: event.isQuestion
      );

      ResultCount<PostAggregation> postUsers =
      ResultCount.fromJson(response.data, PostAggregation.fromJson);

      if (postUsers.resultList.isEmpty) {
        emit(PostsEmptyState());
      } else {
        emit(PostsLoadedState(postUsers: postUsers));
      }
    } catch (error) {
      emit(const PostsLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}