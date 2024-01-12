import 'package:cay_khe/repositories/bookmark_repository.dart';
import 'package:cay_khe/ui/views/profile/blocs/bookmarks_tab/bookmarks_tab_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarksTabProvider extends StatelessWidget {
  final Widget child;
  final String username;
  final int page;
  final int limit;
  final bool isPostBookmarks;

  const BookmarksTabProvider(
      {super.key,
      required this.child,
      required this.username,
      required this.page,
      required this.limit,
      required this.isPostBookmarks});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookmarksTabBloc>(
      create: (context) {
        final bloc = BookmarksTabBloc(bookmarkRepository: BookmarkRepository())
          ..add(LoadBookmarksEvent(
              username: username,
              page: page,
              limit: limit,
              isPostBookmarks: isPostBookmarks));

        return bloc;
      },
      child: child,
    );
  }
}
