import 'package:cay_khe/dtos/series_dto.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/series.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dtos/jwt_payload.dart';
import '../../../../dtos/result_count.dart';
import '../../../../repositories/post_repository.dart';
import '../../../common/utils/message_from_exception.dart';

part 'cu_series_event.dart';
part 'cu_series_state.dart';

class CuSeriesBloc extends Bloc<CuSeriesEvent, CuSeriesState> {
  final SeriesRepository _seriesRepository;
  final PostRepository _postRepository;

  CuSeriesBloc(
      {required PostRepository postRepository,
      required SeriesRepository seriesRepository})
      : _postRepository = postRepository,
        _seriesRepository = seriesRepository,
        super(CuSeriesInitState()) {
    on<InitEmptySeriesEvent>(_initEmptySeries);
    on<LoadSeriesEvent>(_loadSeries);
    on<CuSeriesOperationEvent>(_cuSeries);
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

      var response = await _seriesRepository.getOne(event.id);
      Series series = Series.fromJson(response.data);

      var resultCountJson = await _postRepository.getByUser(JwtPayload.sub!);
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
        }
      }

      String message = getMessageFromException(error);
      emit(CuSeriesLoadErrorState(message: message));
    }
  }

  Future<void> _cuSeries(
      CuSeriesOperationEvent event, Emitter<CuSeriesState> emit) async {
    try {
      if (event.seriesDTO.isPrivate) {
        emit(CuPrivateSeriesWaitingState(
            postUsers: event.postUsers,
            selectedPostUsers: event.selectedPostUsers,
            series: event.series,
            isEditMode: event.isEditMode));
      } else {
        emit(CuPublicSeriesWaitingState(
            postUsers: event.postUsers,
            selectedPostUsers: event.selectedPostUsers,
            series: event.series,
            isEditMode: event.isEditMode));
      }

      Response<dynamic> response;

      if (event.isCreate) {
        response = await _seriesRepository.add(event.seriesDTO);
        Series series = Series.fromJson(response.data);
        emit(SeriesCreatedState(series: series));
      } else {
        response = await _seriesRepository.update(
            event.series!.id!, event.seriesDTO);
        Series series = Series.fromJson(response.data);
        emit(SeriesUpdatedState(series: series));
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          emit(const SeriesNotFoundState(message: "Không tìm thấy series"));
        } else if (error.response?.statusCode == 403) {
          emit(const UnAuthorizedState(
              message:
                  "Bạn không có quyền để thực hiện chức năng trên series này"));
        }

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
