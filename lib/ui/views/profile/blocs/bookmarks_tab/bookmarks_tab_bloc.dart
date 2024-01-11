import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/bookmark_repository.dart';

part 'bookmarks_tab_event.dart';

part 'bookmarks_tab_state.dart';

class BookmarksTabBloc extends Bloc<BookmarksTabEvent, BookmarksTabState> {
  final BookmarkRepository _bookmarkRepository;

  BookmarksTabBloc({required BookmarkRepository bookmarkRepository})
      : _bookmarkRepository = bookmarkRepository,
        super(BookmarksInitialState()) {
    on<LoadBookmarksEvent>(_loadBookmarks);
    on<ConfirmDeleteEvent>(_confirmDelete);
    on<CancelDeleteEvent>(_cancelDelete);
  }

  Future<void> _loadBookmarks(
      LoadBookmarksEvent event, Emitter<BookmarksTabState> emit) async {
    try {
      // Response<dynamic> response = await _bookmarkRepository.getByUser(
      //   event.username,
      //   page: event.page,
      //   limit: event.limit,
      // );
      //
      // ResultCount<BookmarksUser> bookmarkUsers =
      //     ResultCount.fromJson(response.data, BookmarksUser.fromJson);
      //
      // if (bookmarkUsers.resultList.isEmpty) {
      //   emit(BookmarksEmptyState());
      // } else {
      //   emit(BookmarksLoadedState(bookmarkUsers: bookmarkUsers));
      // }
    } catch (error) {
      // emit(const BookmarksLoadErrorState(
      //     message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<BookmarksTabState> emit) async {
    // try {
    //   await _bookmarkRepository.delete(event.bookmarkUser.id!);
    //   emit(BookmarksDeleteSuccessState(bookmarkUser: event.bookmarkUser));
    // } catch (error) {
    //   String message = getMessageFromException(error);
    //   emit(BookmarksTabErrorState(message: message));
    // }
  }

  void _cancelDelete(CancelDeleteEvent event, Emitter<BookmarksTabState> emit) {
    // emit(BookmarksDialogCanceledState());
  }
}
