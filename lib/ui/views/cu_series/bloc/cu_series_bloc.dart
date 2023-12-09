import 'package:cay_khe/dtos/series_dto.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/series.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dtos/jwt_payload.dart';
import '../../../../models/result_count.dart';
import '../../../../repositories/post_repository.dart';
import '../../../common/utils/message_from_exception.dart';

part 'cu_series_event.dart';
part 'cu_series_state.dart';

class CuSeriesBloc extends Bloc<CuSeriesEvent, CuSeriesState> {
  final SeriesRepository seriesRepository;
  final PostRepository postRepository;

  CuSeriesBloc({required this.postRepository, required this.seriesRepository})
      : super(CuSeriesInitState()) {
    on<InitEmptySeriesEvent>(_initEmptySeries);
    on<LoadSeriesEvent>(_loadSeries);
    on<CreateSeriesEvent>(_createSeries);
    on<UpdateSeriesEvent>(_updateSeries);
    on<SwitchModeEvent>(_switchMode);
    on<AddPostEvent>(_addPost);
    on<RemovePostEvent>(_removePost);
  }

  void _initEmptySeries(
      InitEmptySeriesEvent event, Emitter<CuSeriesState> emit) {
    emit(const CuSeriesEmptyState(
      series: null,
      isEditMode: true,
      postUsers: [],
      selectedPostUsers: [],
    ));
  }

  Future<void> _loadSeries(
      LoadSeriesEvent event, Emitter<CuSeriesState> emit) async {
    try {
      if (JwtPayload.sub == null) {
        emit(const UnAuthorizedState(
            message: "Bạn cần đăng nhập để thực hiện chức năng này"));
        return;
      }

      var response = await seriesRepository.getOne(event.id);
      Series series = Series.fromJson(response.data);

      var resultCountJson = await postRepository.getByUser(JwtPayload.sub!);
      ResultCount<PostAggregation> resultCount =
          ResultCount.fromJson(resultCountJson.data, PostAggregation.fromJson);
      List<PostAggregation> postUsers =
          resultCount.resultList.map((e) => e).toList();
      List<PostAggregation> selectedPostUsers = [];
      postUsers.removeWhere((postUser) {
        if (series.postIds.contains(postUser.id)) {
          selectedPostUsers.add(postUser);
          return true;
        }
        return false;
      });

      emit(CuSeriesLoadedState(
        series: series,
        isEditMode: true,
        postUsers: postUsers,
        selectedPostUsers: selectedPostUsers,
      ));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const SeriesNotFoundState(message: "Không tìm thấy series"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
                  "Bạn không có quyền để thực hiện chức năng trên series này"));
        } else {
          String message = getMessageFromException(error);
          emit(CuSeriesLoadErrorState(message: message));
        }
      }
    }
  }

  Future<void> _createSeries(
      CreateSeriesEvent event, Emitter<CuSeriesState> emit) async {
    try {
      SeriesDTO seriesDTO = event.seriesDTO;

      var response = await seriesRepository.add(seriesDTO);
      Series series = Series.fromJson(response.data);

      emit(SeriesCreatedState(series: series));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const SeriesNotFoundState(message: "Không tìm thấy series"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
              "Bạn không có quyền để thực hiện chức năng trên series này"));
        } else {
          String message = getMessageFromException(error);
          emit(CuOperationErrorState(
              message: message,
              series: event.series,
              isEditMode: event.isEditMode,
              postUsers: event.postUsers,
              selectedPostUsers: event.selectedPostUsers));
        }
      }
    }
  }

  Future<void> _updateSeries(
      UpdateSeriesEvent event, Emitter<CuSeriesState> emit) async {
    try {
      SeriesDTO seriesDTO = event.seriesDTO;

      var response =
          await seriesRepository.update(event.series!.id!, seriesDTO);
      Series series = Series.fromJson(response.data);

      emit(SeriesUpdatedState(series: series));
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const SeriesNotFoundState(message: "Không tìm thấy series"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
                  "Bạn không có quyền để thực hiện chức năng trên series này"));
        } else {
          String message = getMessageFromException(error);
          emit(CuOperationErrorState(
              message: message,
              series: event.series,
              isEditMode: event.isEditMode,
              postUsers: event.postUsers,
              selectedPostUsers: event.selectedPostUsers));
        }
      }
    }
  }

  void _switchMode(SwitchModeEvent event, Emitter<CuSeriesState> emit) {
    emit(SwitchModeState(
      series: event.series,
      isEditMode: event.isEditMode,
      postUsers: event.postUsers,
      selectedPostUsers: event.selectedPostUsers,
    ));
  }

  void _addPost(AddPostEvent event, Emitter<CuSeriesState> emit) {
    var postUsers = [...event.postUsers];
    postUsers.remove(event.postUser);
    event.selectedPostUsers.add(event.postUser);

    emit(AddedPostState(
      series: event.series,
      isEditMode: event.isEditMode,
      postUsers: postUsers,
      selectedPostUsers: event.selectedPostUsers,
    ));
  }

  void _removePost(RemovePostEvent event, Emitter<CuSeriesState> emit) {
    var postUsers = [...event.postUsers, event.postUser];
    event.selectedPostUsers.remove(event.postUser);
    emit(RemovedPostState(
      series: event.series,
      isEditMode: event.isEditMode,
      postUsers: postUsers,
      selectedPostUsers: event.selectedPostUsers,
    ));
  }
}
