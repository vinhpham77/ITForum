part of 'bookmarks_tab_bloc.dart';

@immutable
sealed class BookmarksTabEvent extends Equatable {
  const BookmarksTabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBookmarksEvent extends BookmarksTabEvent {
  final String username;
  final int page;
  final int limit;

  const LoadBookmarksEvent({
    required this.username,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [username, page, limit];
}

final class ConfirmDeleteEvent extends BookmarksTabEvent {
  // final BookmarksUser seriesUser;
  //
  // const ConfirmDeleteEvent({required this.seriesUser});
  //
  // @override
  // List<Object?> get props => [seriesUser];
}

final class CancelDeleteEvent extends BookmarksTabEvent {}