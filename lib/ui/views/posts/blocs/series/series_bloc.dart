import 'package:cay_khe/dtos/result_count.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_user.dart';

part 'series_event.dart';

part 'series_state.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SeriesRepository _seriesRepository = SeriesRepository();

  SeriesBloc() : super(SeriesInitialState()) {
    on<LoadSeriesEvent>(_loadPosts);
  }

  Future<void> _loadPosts(
      LoadSeriesEvent event, Emitter<SeriesState> emit) async {
    try {
      Response<dynamic> response = await _seriesRepository.getSeriesUser(
        page: event.page,
        limit: event.limit,
      );

      ResultCount<SeriesUser> seriesUser =
          ResultCount.fromJson(response.data, SeriesUser.fromJson);

      if (seriesUser.resultList.isEmpty) {
        emit(SeriesEmptyState());
      } else {
        emit(SeriesLoadedState(seriesUser: seriesUser));
      }
    } catch (error) {
      emit(const SeriesLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}
