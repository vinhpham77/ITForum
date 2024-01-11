part of 'bookmarks_tab_bloc.dart';

@immutable
sealed class BookmarksTabState extends Equatable {
  const BookmarksTabState();

  @override
  List<Object?> get props => [];
}

final class BookmarksInitialState extends BookmarksTabState {}

final class BookmarksEmptyState extends BookmarksTabState {}

final class BookmarksLoadedState extends BookmarksTabState {
  // final ResultCount<BookmarksUser> seriesUsers;
  //
  // const BookmarksLoadedState({required this.seriesUsers});
  //
  // @override
  // List<Object?> get props => [seriesUsers];
}

// final class BookmarksDeleteSuccessState extends BookmarksTabState {
//   final BookmarksUser seriesUser;
//
//   const BookmarksDeleteSuccessState({required this.seriesUser});
//
//   @override
//   List<Object?> get props => [seriesUser];
// }
//
// final class BookmarksTabErrorState extends BookmarksTabState {
//   final String message;
//
//   const BookmarksTabErrorState({required this.message});
//
//   @override
//   List<Object?> get props => [message];
// }
//
// final class BookmarksLoadErrorState extends BookmarksTabState {
//   final String message;
//
//   const BookmarksLoadErrorState({required this.message});
//
//   @override
//   List<Object?> get props => [message];
// }
//
// class BookmarksDialogCanceledState extends BookmarksTabState {}