import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/dtos/result_count.dart';
import 'package:cay_khe/repositories/bookmark_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_user.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository _bookmarkRepository  = BookmarkRepository();

  BookmarkBloc() : super(BookmarkInitialState()) {
    on<LoadBookmarkPostEvent>(_loadBookmarkPosts);
    on<LoadBookmarkSeriesEvent>(_loadBookmarkSeries);
  }

  Future<void> _loadBookmarkPosts(LoadBookmarkPostEvent event, Emitter<BookmarkState> emit) async {
    try {
      Response<dynamic> response = await _bookmarkRepository.getPostByUserName(
        username: event.username,
        page: event.page,
        limit: event.limit,
        isQuestion: event.isQuestion
      );

      ResultCount<PostAggregation> postUsers =
      ResultCount.fromJson(response.data, PostAggregation.fromJson);

      if (postUsers.resultList.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        emit(BookmarkPostLoadedState(postUsers: postUsers));
      }
    } catch (error) {
      emit(const BookmarkLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  Future<void> _loadBookmarkSeries(LoadBookmarkSeriesEvent event, Emitter<BookmarkState> emit) async {
    try {
      Response<dynamic> response = await _bookmarkRepository.getSeriesByUserName(
        username: event.username,
        page: event.page,
        limit: event.limit,
      );

      ResultCount<SeriesUser> seriesUsers =
      ResultCount.fromJson(response.data, SeriesUser.fromJson);

      if (seriesUsers.resultList.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        emit(BookmarkSeriesLoadedState(seriesUser: seriesUsers));
      }
    } catch (error) {
      emit(const BookmarkLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}