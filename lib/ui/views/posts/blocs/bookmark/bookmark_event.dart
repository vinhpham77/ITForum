part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBookmarkPostEvent extends BookmarkEvent {
  final String username;
  final int page;
  final int limit;
  final bool isQuestion;

  const LoadBookmarkPostEvent({
    required this.username,
    required this.page,
    required this.limit,
    required this.isQuestion
  });

  @override
  List<Object?> get props => [page, limit, isQuestion];
}

final class LoadBookmarkSeriesEvent extends BookmarkEvent {
  final String username;
  final int page;
  final int limit;

  const LoadBookmarkSeriesEvent({
    required this.username,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [page, limit];
}