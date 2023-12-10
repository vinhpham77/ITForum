part of 'series_bloc.dart';

@immutable
sealed class SeriesEvent extends Equatable {
  const SeriesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadSeriesEvent extends SeriesEvent {
  final int page;
  final int limit;

  const LoadSeriesEvent({
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [page, limit];
}