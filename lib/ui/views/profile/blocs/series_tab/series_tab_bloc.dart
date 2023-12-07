import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/series_user.dart';
import '../../../../../models/result_count.dart';
import '../../../../../repositories/series_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'series_tab_event.dart';
part 'series_tab_state.dart';

class SeriesTabBloc extends Bloc<SeriesTabEvent, SeriesTabState> {
  final SeriesRepository _seriesRepository = SeriesRepository();

  SeriesTabBloc() : super(SeriesInitialState()) {
    on<LoadSeriesEvent>(_loadSeries);
    on<ConfirmDeleteEvent>(_confirmDelete);
    on<CancelDeleteEvent>(_cancelDelete);
  }

  Future<void> _loadSeries(LoadSeriesEvent event, Emitter<SeriesTabState> emit) async {
    try {
      Response<dynamic> response = await _seriesRepository.getByUser(
        event.username,
        page: event.page,
        limit: event.limit,
      );

      ResultCount<SeriesUser> seriesUsers =
      ResultCount.fromJson(response.data, SeriesUser.fromJson);

      if (seriesUsers.resultList.isEmpty) {
        emit(SeriesEmptyState());
      } else {
        emit(SeriesLoadedState(seriesUsers: seriesUsers));
      }
    } catch (error) {
      emit(const SeriesLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<SeriesTabState> emit) async {
    try {
      await _seriesRepository.delete(event.seriesUser.id!);
      emit(SeriesDeleteSuccessState(seriesUser: event.seriesUser));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(SeriesTabErrorState(message: message));
    }
  }

  void _cancelDelete(CancelDeleteEvent event, Emitter<SeriesTabState> emit) {
    emit(SeriesDialogCanceledState());
  }
}
