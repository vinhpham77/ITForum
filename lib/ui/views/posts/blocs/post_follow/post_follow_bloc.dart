import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/post_aggregation_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'post_follow_event.dart';
part 'post_follow_state.dart';

class PostFollowBloc extends Bloc<PostFollowEvent, PostFollowState> {
  final PostAggregationRepository _postAggregatioRepository = PostAggregationRepository();

  PostFollowBloc() : super(PostFollowInitialState()) {
    on<LoadPostsEvent>(_loadPosts);
  }

  Future<void> _loadPosts(LoadPostsEvent event, Emitter<PostFollowState> emit) async {
    try {
      Response<dynamic> response = await _postAggregatioRepository.getFollow(
          page: event.page,
          limit: event.limit,
          isQuestion: event.isQuestion
      );

      ResultCount<PostAggregation> postUsers =
      ResultCount.fromJson(response.data, PostAggregation.fromJson);

      if (postUsers.resultList.isEmpty) {
        emit(PostFollowEmptyState());
      } else {
        emit(PostFollowLoadedState(postUsers: postUsers));
      }
    } catch (error) {
      emit(const PostFollowLoadErrorState(
        message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}