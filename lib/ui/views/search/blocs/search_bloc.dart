import 'package:cay_khe/dtos/result_count.dart';
import 'package:cay_khe/dtos/series_user.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/repositories/post_aggregation_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/series_repository.dart';


part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostAggregationRepository _postRepository = PostAggregationRepository();
  final SeriesRepository _seriesRepository = SeriesRepository();

  SearchBloc() : super(FollowInitialState()) {
    on<LoadPostsEvent>(_loadPostsSearch);
    on<LoadSeriesEvent>(_loadSeriesSearch);
  }

  Future<void> _loadPostsSearch(
      LoadPostsEvent event, Emitter<SearchState> emit) async {
    try {
      Response<dynamic> response = await _postRepository.getSearch(
          fieldSearch: event.fieldSearch, searchContent: event.searchContent,
          sort: event.sort, sortField: event.sortField, page: event.page, limit: event.limit);

      ResultCount<PostAggregation> posts = ResultCount.fromJson(response.data, PostAggregation.fromJson);

      if (posts.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(PostLoadedState(posts: posts));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
  Future<void> _loadSeriesSearch(
      LoadSeriesEvent event, Emitter<SearchState> emit) async {
    try {
      Response<dynamic> response = await _seriesRepository.getSearch(
          fieldSearch: event.fieldSearch, searchContent: event.searchContent,
          sort: event.sort, sortField: event.sortField, page: event.page, limit: event.limit);

      ResultCount<SeriesUser> seriesPost =
      ResultCount.fromJson(response.data, SeriesUser.fromJson);

      if (seriesPost.resultList.isEmpty) {
        emit(FollowEmptyState());
      } else {
        emit(SeriesLoadedState(seriesPost: seriesPost));
      }
    } catch (error) {
      emit(const FollowLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}