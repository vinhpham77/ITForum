import 'package:cay_khe/dtos/result_count.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/repositories/follow_repository.dart';
import 'package:cay_khe/ui/views/profile/blocs/follows_tab/follows_tab_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/post_aggregation_repository.dart';
import '../../../../../dtos/series_user.dart';
import '../../../../../repositories/series_repository.dart';

part 'follow_event.dart';

part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final PostAggregationRepository _postAggregationRepository =
      PostAggregationRepository();
  final FollowRepository _followRepository = FollowRepository();

  FollowBloc() : super(FollowInitialState()) {
    on<LoadPostsFollowEvent>(_loadPosts);
  }

  Future<void> _loadPosts(
      LoadPostsFollowEvent event, Emitter<FollowState> emit) async {
    try {
      Response<dynamic> response = await _postAggregationRepository.getFollow(
          page: event.page, limit: event.limit, isQuestion: event.isQuestion);

      ResultCount<PostAggregation> postUsers =
          ResultCount.fromJson(response.data, PostAggregation.fromJson);

      if (postUsers.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(PostFollowLoadedState(postUsers: postUsers));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  Future<void> _loadBookmarkSeries(LoadSeriesFollowEvent event, Emitter<FollowState> emit) async {
    try {
      Response<dynamic> response = await _followRepository.getSeries(
        page: event.page,
        limit: event.limit,
      );

      ResultCount<SeriesUser> seriesUsers =
      ResultCount.fromJson(response.data, SeriesUser.fromJson);

      if (seriesUsers.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(SeriesFollowLoadedState(seriesUser: seriesUsers));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
