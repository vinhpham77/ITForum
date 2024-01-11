part of 'cu_series_bloc.dart';

@immutable
sealed class CuSeriesEvent extends Equatable {
  const CuSeriesEvent();

  @override
  List<Object?> get props => [];
}

final class InitEmptySeriesEvent extends CuSeriesEvent {}

sealed class CuSeriesSubEvent extends CuSeriesEvent {
  final Series? series;
  final List<PostAggregation> postUsers;
  final List<PostAggregation> selectedPostUsers;
  final bool isEditMode;

  const CuSeriesSubEvent({
    required this.isEditMode,
    required this.series,
    required this.selectedPostUsers,
    required this.postUsers,
  });

  @override
  List<Object?> get props => [isEditMode, series, selectedPostUsers, postUsers];
}

final class AddPostEvent extends CuSeriesSubEvent {
  final PostAggregation postUser;

  const AddPostEvent(
      {required this.postUser,
      required super.isEditMode,
      required super.series,
      required super.selectedPostUsers,
      required super.postUsers});

  @override
  List<Object?> get props => [
        postUser,
        super.isEditMode,
        super.series,
        super.selectedPostUsers,
        super.postUsers
      ];
}

final class RemovePostEvent extends CuSeriesSubEvent {
  final PostAggregation postUser;

  const RemovePostEvent(
      {required this.postUser,
      required super.isEditMode,
      required super.series,
      required super.selectedPostUsers,
      required super.postUsers});

  @override
  List<Object?> get props => [
        postUser,
        super.isEditMode,
        super.series,
        super.selectedPostUsers,
        super.postUsers
      ];
}

final class LoadSeriesEvent extends CuSeriesEvent {
  final String id;

  const LoadSeriesEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

final class CuSeriesOperationEvent extends CuSeriesSubEvent {
  final SeriesDTO seriesDTO;
  final bool isCreate;

  const CuSeriesOperationEvent(
      {required this.seriesDTO,
      required this.isCreate,
      required super.isEditMode,
      required super.series,
      required super.selectedPostUsers,
      required super.postUsers});

  @override
  List<Object?> get props => [
        seriesDTO,
        super.isEditMode,
        super.series,
        super.selectedPostUsers,
        super.postUsers,
        isCreate
      ];
}

final class SwitchModeEvent extends CuSeriesSubEvent {
  const SwitchModeEvent(
      {required super.isEditMode,
      required super.series,
      required super.selectedPostUsers,
      required super.postUsers});
}
