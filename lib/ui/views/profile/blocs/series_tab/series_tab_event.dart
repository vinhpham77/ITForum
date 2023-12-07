part of 'series_tab_bloc.dart';

@immutable
sealed class SeriesTabEvent extends Equatable {
  const SeriesTabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadSeriesEvent extends SeriesTabEvent {
  final String username;
  final int page;
  final int limit;

  const LoadSeriesEvent({
    required this.username,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [username, page, limit];
}

final class ConfirmDeleteEvent extends SeriesTabEvent {
  final SeriesUser seriesUser;

  const ConfirmDeleteEvent({required this.seriesUser});

  @override
  List<Object?> get props => [seriesUser];
}

final class CancelDeleteEvent extends SeriesTabEvent {}