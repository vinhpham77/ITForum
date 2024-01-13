import 'package:cay_khe/dtos/bookmark_item.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/result_count.dart';
import '../../../../../repositories/bookmark_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'bookmarks_tab_event.dart';

part 'bookmarks_tab_state.dart';

class BookmarksTabBloc extends Bloc<BookmarksTabEvent, BookmarksTabState> {
  final BookmarkRepository _bookmarkRepository;

  BookmarksTabBloc({required BookmarkRepository bookmarkRepository})
      : _bookmarkRepository = bookmarkRepository,
        super(BookmarksInitialState()) {
    on<LoadBookmarksEvent>(_loadBookmarks);
    on<ConfirmDeleteEvent>(_confirmDelete);
  }

  Future<void> _loadBookmarks(
      LoadBookmarksEvent event, Emitter<BookmarksTabState> emit) async {
    try {
      late Response<dynamic> response;
      late ResultCount<BookmarkItem> bookmarkItems;

      if (event.isPostBookmarks) {
        response = await _bookmarkRepository.getPostByUserName(
            username: event.username, page: event.page, limit: event.limit);
        bookmarkItems =
            ResultCount.fromJson(response.data, PostBookmark.fromJson);
      } else {
        response = await _bookmarkRepository.getSeriesByUserName(
            username: event.username, page: event.page, limit: event.limit);
        bookmarkItems =
            ResultCount.fromJson(response.data, SeriesBookmark.fromJson);
      }

      if (bookmarkItems.resultList.isEmpty) {
        emit(BookmarksEmptyState());
      } else {
        emit(BookmarksLoadedState(
            bookmarkItems: bookmarkItems,
            isPostBookmarks: event.isPostBookmarks));
      }
    } catch (error) {
      emit(const BookmarksLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<BookmarksTabState> emit) async {
    try {
      await _bookmarkRepository.unBookmark(event.bookmarkItem.id!);
      emit(BookmarksDeleteSuccessState(bookmarkItem: event.bookmarkItem));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(BookmarksTabErrorState(bookmarkItems: event.bookmarkItems, message: message, isPostBookmarks: event.isPostBookmarks));
    }
  }
}
