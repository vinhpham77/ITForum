import 'package:cay_khe/ui/views/profile/blocs/bookmarks_tab/bookmarks_tab_bloc.dart';
import 'package:cay_khe/ui/views/profile/blocs/bookmarks_tab/bookmarks_tab_provider.dart';
import 'package:cay_khe/ui/views/profile/widgets/bookmarks_tab/post_bookmark_item.dart';
import 'package:cay_khe/ui/views/profile/widgets/bookmarks_tab/series_bookmark_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/bookmark_item.dart';
import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/notify_type.dart';
import '../../../../../dtos/pagination_states.dart';
import '../../../../../dtos/result_count.dart';
import '../../../../router.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination2.dart';
import '../../blocs/profile/profile_bloc.dart';

const bookmarkDropdownItems = <Map<String, String>>[
  {'posts': 'Bài viết'},
  {'series': 'Series'}
];

class BookmarksTab extends StatelessWidget {
  final String username;
  final bool isPostBookmarks;
  final int page;
  final int limit;

  const BookmarksTab(
      {super.key,
      required this.username,
      required this.page,
      required this.limit,
      required this.isPostBookmarks});

  int get itemIndex => isPostBookmarks ? 0 : 1;

  String get itemKey => bookmarkDropdownItems[itemIndex].keys.first;

  String get itemValue => bookmarkDropdownItems[itemIndex].values.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
            children: [
              const Text("Sắp xếp theo:"),
              const SizedBox(width: 8),
              DropdownButtonHideUnderline(
                child:  DropdownButton<String>(
                  value: itemKey,
                  onChanged: (String? newValue) {
                    newValue = newValue?.toLowerCase();
                    appRouter.go('/profile/$username/bookmarks/$newValue');
                  },
                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 8),
                  items: bookmarkDropdownItems.map((Map<String, String> map) {
                    return DropdownMenuItem<String>(
                      value: map.keys.first,
                      child: Text(map.values.first),
                    );
                  }).toList(),
                ),
              ),
            ]
        ),
        buildBookmarksTab(context),
      ],
    );
  }

  Widget buildBookmarksTab(BuildContext context) {
    return BookmarksTabProvider(
      username: username,
      page: page,
      limit: limit,
      isPostBookmarks: isPostBookmarks,
      child: BlocListener<BookmarksTabBloc, BookmarksTabState>(
        listener: (context, state) {
          if (state is BookmarksDeleteSuccessState) {
            showTopRightSnackBar(
              context,
              "Xoá bookmark ${itemValue.toLowerCase()} \"${state.bookmarkItem.title ?? 'không tồn tại'}\" thành công!",
              NotifyType.success,
            );

            context.read<BookmarksTabBloc>().add(LoadBookmarksEvent(
                  username: username,
                  page: page,
                  limit: limit,
                  isPostBookmarks: isPostBookmarks,
                ));

            final ProfileBloc profileBloc = context.read<ProfileBloc>();
            final profileState = profileBloc.state as ProfileSubState;

            profileBloc.add(DecreaseBookmarksCountEvent(
              isFollowing: profileState.isFollowing,
              profileStats: profileState.profileStats,
              tagCounts: profileState.tagCounts,
              user: profileState.user,
              bookmarkItem: state.bookmarkItem
            ));
          } else if (state is BookmarksTabErrorState) {
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          }
        },
        child: BlocBuilder<BookmarksTabBloc, BookmarksTabState>(
            builder: (context, state) {
          if (state is BookmarksEmptyState) {
            return buildSimpleContainer(
              child: Text(
                "Không có bookmark ${itemValue.toLowerCase()} nào!",
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else if (state is BookmarksLoadedState) {
            return Column(
              children: [
                buildBookmarkItemList(context, state.bookmarkItems),
                buildPagination(state.bookmarkItems),
              ],
            );
          } else if (state is BookmarksLoadErrorState) {
            return buildSimpleContainer(
              child: Text(state.message, style: const TextStyle(fontSize: 16)),
            );
          } else if (state is BookmarksTabErrorState) {
            return Column(
              children: [
                buildBookmarkItemList(context, state.bookmarkItems),
                buildPagination(state.bookmarkItems),
              ],
            );
          }

          return buildSimpleContainer(child: const CircularProgressIndicator());
        }),
      ),
    );
  }

  Padding buildBookmarkItemList(
      BuildContext context, ResultCount<BookmarkItem> bookmarkItems) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      child: Column(
        children: [
          for (var bookmarkItem in bookmarkItems.resultList)
            buildOneRow(context, bookmarkItem, bookmarkItems),
        ],
      ),
    );
  }

  Container buildSimpleContainer({required Widget child}) => Container(
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: child);

  Row buildOneRow(BuildContext context, BookmarkItem bookmarkItem,
      ResultCount<BookmarkItem> bookmarkItems) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            transform: Matrix4.translationValues(-8.0, 0, 0),
            child: isPostBookmarks
                ? PostBookmarkItem(postBookmark: bookmarkItem as PostBookmark)
                : SeriesBookmarkItem(
                    seriesBookmark: bookmarkItem as SeriesBookmark),
          ),
        ),
        if (username == JwtPayload.sub)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent[400],
                side: BorderSide(color: Colors.redAccent[400]!, width: 1),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                textStyle: const TextStyle(fontSize: 13)),
            onPressed: () => showDeleteConfirmationDialog(
                context, bookmarkItem, bookmarkItems),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, size: 16),
                SizedBox(width: 4),
                Text("Xoá")
              ],
            ),
          ),
      ],
    );
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context,
      BookmarkItem bookmarkItem,
      ResultCount<BookmarkItem> bookmarkItems) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Bạn có chắc chắn muốn xoá bookmark ${itemValue.toLowerCase()} "${bookmarkItem.title ?? 'không tồn tại'}" không?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Xác nhận'),
            onPressed: () {
              context.read<BookmarksTabBloc>().add(ConfirmDeleteEvent(
                  bookmarkItem: bookmarkItem, bookmarkItems: bookmarkItems, isPostBookmarks: isPostBookmarks));
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Pagination2 buildPagination(ResultCount<BookmarkItem> bookmarkItems) {
    return Pagination2(
        pagingStates: PaginationStates(
            count: bookmarkItems.count,
            limit: limit,
            currentPage: page,
            range: 2,
            path: "/profile/$username/bookmarks/$itemKey",
            params: {}));
  }
}
