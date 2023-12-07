part of 'series_tab_bloc.dart';

@immutable
sealed class SeriesTabState extends Equatable {
  const SeriesTabState();

  @override
  List<Object?> get props => [];
}


final class SeriesInitialState extends SeriesTabState {}

final class SeriesEmptyState extends SeriesTabState {}

final class SeriesLoadedState extends SeriesTabState {
  final ResultCount<SeriesUser> seriesUsers;

  const SeriesLoadedState({required this.seriesUsers});

  @override
  List<Object?> get props => [seriesUsers];
}

final class SeriesDeleteSuccessState extends SeriesTabState {
  final SeriesUser seriesUser;

  const SeriesDeleteSuccessState({required this.seriesUser});

  @override
  List<Object?> get props => [seriesUser];
}

final class SeriesTabErrorState extends SeriesTabState {
  final String message;

  const SeriesTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SeriesLoadErrorState extends SeriesTabState {
  final String message;

  const SeriesLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SeriesDialogCanceledState extends SeriesTabState {}