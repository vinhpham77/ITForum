import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_user.dart';

part 'series_event.dart';
part 'series_state.dart';

class PostFollowBloc extends Bloc<SeriesEvent, SeriesState> {
  final SeriesRepository _seriesRepository = SeriesRepository();

  PostFollowBloc() : super(SeriesInitialState()) {
    on<LoadSeriesEvent>(_loadPosts);
  }

  Future<void> _loadPosts(LoadSeriesEvent event, Emitter<SeriesState> emit) async {
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
      if(JwtPayload.sub == null)
        emit(const SeriesLoadErrorState(
            message: "Vui long đăng nhập để xem!"));
      else
        emit(const SeriesLoadErrorState(
            message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }
}