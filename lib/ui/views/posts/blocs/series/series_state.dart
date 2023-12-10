part of 'series_bloc.dart';

@immutable
sealed class SeriesState extends Equatable {
  const SeriesState();

  @override
  List<Object?> get props => [];
}

final class SeriesInitialState extends SeriesState {}

final class SeriesEmptyState extends SeriesState {}

final class SeriesLoadedState extends SeriesState {
  final ResultCount<SeriesUser> seriesUser;

  const SeriesLoadedState({required this.seriesUser});

  @override
  List<Object?> get props => [seriesUser];
}

final class SeriesLoadErrorState extends SeriesState {
  final String message;

  const SeriesLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}