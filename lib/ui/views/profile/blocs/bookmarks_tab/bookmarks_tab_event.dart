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
  final bool isPostBookmarks;

  const LoadBookmarksEvent({
    required this.isPostBookmarks,
    required this.username,
    required this.page,
    required this.limit,
  });

  @override
  List<Object?> get props => [username, page, limit, isPostBookmarks];
}

final class BookmarksTabSubEvent extends BookmarksTabEvent {
  final ResultCount<BookmarkItem> bookmarkItems;

  const BookmarksTabSubEvent({required this.bookmarkItems});

  @override
  List<Object?> get props => [bookmarkItems];
}

final class ConfirmDeleteEvent extends BookmarksTabSubEvent {
  final BookmarkItem bookmarkItem;

  const ConfirmDeleteEvent({
    required this.bookmarkItem,
    required super.bookmarkItems,
  });

  @override
  List<Object?> get props => [bookmarkItem, bookmarkItems];
}

