part of 'series_tab_bloc.dart';

@immutable
sealed class SeriesTabEvent extends Equatable {
  const SeriesTabEvent();

  @override
  List<Object?> get props => [];
}

final class SeriesSubEvent extends SeriesTabEvent {
  final ResultCount<SeriesUser> seriesUsers;

  const SeriesSubEvent({
    required this.seriesUsers,
  });

  @override
  List<Object?> get props => [seriesUsers];
}

final class LoadSeriesEvent extends SeriesTabEvent {
  final String username;
  final int page;
  final int limit;

  const LoadSeriesEvent(
      {required this.username, required this.page, required this.limit});

  @override
  List<Object?> get props => [username, page, limit];
}

final class ConfirmDeleteEvent extends SeriesSubEvent {
  final SeriesUser seriesUser;

  const ConfirmDeleteEvent({
    required this.seriesUser,
    required super.seriesUsers,
  });

  @override
  List<Object?> get props => [seriesUser, seriesUsers];
}

final class CancelDeleteEvent extends SeriesSubEvent {
  const CancelDeleteEvent({required super.seriesUsers});
}
