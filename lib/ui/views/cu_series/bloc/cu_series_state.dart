part of 'cu_series_bloc.dart';

@immutable
sealed class CuSeriesState extends Equatable {
  const CuSeriesState();

  @override
  List<Object?> get props => [];
}

sealed class CuSeriesSubState extends CuSeriesState {
  final Series? series;
  final List<PostAggregation> postUsers;
  final List<PostAggregation> selectedPostUsers;
  final bool isEditMode;

  const CuSeriesSubState({
    required this.isEditMode,
    required this.series,
    required this.selectedPostUsers,
    required this.postUsers,
  });

  @override
  List<Object?> get props => [isEditMode, series, selectedPostUsers, postUsers];
}

final class CuSeriesInitState extends CuSeriesState {}

final class CuSeriesEmptyState extends CuSeriesSubState {
  const CuSeriesEmptyState({
    super.isEditMode = true,
    super.series,
    super.selectedPostUsers = const [],
    super.postUsers = const [],
  });
}

final class CuSeriesLoadedState extends CuSeriesSubState {
  const CuSeriesLoadedState(
      {super.isEditMode = true,
      required super.series,
      required super.selectedPostUsers,
      required super.postUsers});
}

sealed class CuSeriesErrorState extends CuSeriesState {
  final String message;

  const CuSeriesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class SeriesNotFoundState extends CuSeriesErrorState {
  const SeriesNotFoundState({required super.message});
}

final class UnAuthorizedState extends CuSeriesErrorState {
  const UnAuthorizedState({required super.message});
}

final class CuSeriesLoadErrorState extends CuSeriesErrorState {
  const CuSeriesLoadErrorState({required super.message});
}

final class CuOperationErrorState extends CuSeriesSubState {
  final String message;

  const CuOperationErrorState({
    required this.message,
    required super.isEditMode,
    required super.series,
    required super.selectedPostUsers,
    required super.postUsers,
  });

  @override
  List<Object?> get props => [
        message,
        super.isEditMode,
        super.series,
        super.selectedPostUsers,
        super.postUsers
      ];
}

final class SeriesCreatedState extends CuSeriesState {
  final Series series;

  const SeriesCreatedState({required this.series});

  @override
  List<Object> get props => [series];
}

final class SeriesUpdatedState extends CuSeriesState {
  final Series series;

  const SeriesUpdatedState({required this.series});

  @override
  List<Object> get props => [series];
}

final class SwitchModeState extends CuSeriesSubState {
  const SwitchModeState({
    required super.isEditMode,
    required super.series,
    required super.selectedPostUsers,
    required super.postUsers,
  });
}

final class AddedPostState extends CuSeriesSubState {
  const AddedPostState({
    required super.isEditMode,
    required super.series,
    required super.selectedPostUsers,
    required super.postUsers,
  });
}

final class RemovedPostState extends CuSeriesSubState {
  const RemovedPostState({
    required super.isEditMode,
    required super.series,
    required super.selectedPostUsers,
    required super.postUsers,
  });
}
