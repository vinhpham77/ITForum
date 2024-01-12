part of 'bookmarks_tab_bloc.dart';

@immutable
sealed class BookmarksTabState extends Equatable {
  const BookmarksTabState();

  @override
  List<Object?> get props => [];
}

final class BookmarksInitialState extends BookmarksTabState {}

final class BookmarksEmptyState extends BookmarksTabState {}

@immutable
sealed class BookmarksTabSubState extends BookmarksTabState {
  final bool isPostBookmarks;
  final ResultCount<BookmarkItem> bookmarkItems;

  const BookmarksTabSubState(
      {required this.bookmarkItems, required this.isPostBookmarks});

  @override
  List<Object?> get props => [isPostBookmarks, bookmarkItems];
}

final class BookmarksLoadedState extends BookmarksTabSubState {
  const BookmarksLoadedState({
    required super.bookmarkItems,
    required super.isPostBookmarks,
  });
}

final class BookmarksDeleteSuccessState extends BookmarksTabState {
  final BookmarkItem bookmarkItem;

  const BookmarksDeleteSuccessState({required this.bookmarkItem});

  @override
  List<Object?> get props => [bookmarkItem];
}

final class BookmarksTabErrorState extends BookmarksTabSubState {
  final String message;

  const BookmarksTabErrorState(
      {required this.message,
      required super.bookmarkItems,
      required super.isPostBookmarks});

  @override
  List<Object?> get props => [message, super.bookmarkItems, super.isPostBookmarks];
}

final class BookmarksLoadErrorState extends BookmarksTabState {
  final String message;

  const BookmarksLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
