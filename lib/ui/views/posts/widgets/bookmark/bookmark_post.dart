import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination.dart';
import '../../blocs/bookmark/bookmark_bloc.dart';
import '../post_feed_item.dart';


class BookmarkPost extends StatefulWidget {
  final String? username;
  final int page;
  final int limit;
  final bool isQuestion;
  final Map<String, String> params;

  const BookmarkPost(
      {super.key,
        required this.username,
        required this.page,
        required this.limit,
        required this.isQuestion,
        required this.params
      });

  @override
  State<BookmarkPost> createState() => _BookmarkPostState();
}

class _BookmarkPostState extends State<BookmarkPost> {
  late BookmarkBloc _bloc;
  late Map<String, String> indexing = widget.isQuestion ? {'name' : 'hỏi đáp', 'path': '/viewquestionbookmark'} :
  {'name' : 'bài viết', 'path': '/viewbookmark'};

  @override
  void initState() {
    super.initState();
    _bloc = BookmarkBloc()
      ..add(LoadBookmarkPostEvent(
        username: widget.username,
        limit: widget.limit,
        page: widget.page,
        isQuestion: widget.isQuestion
      ));
  }

  @override
  void didUpdateWidget(BookmarkPost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.add(LoadBookmarkPostEvent(
        username: widget.username,
        limit: widget.limit,
        page: widget.page,
        isQuestion: widget.isQuestion
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<BookmarkBloc, BookmarkState>(
        listener: (context, state) {
          if (state is BookmarkTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<BookmarkBloc, BookmarkState>(
          builder: (context, state) {
            if (state is BookmarkEmptyState) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Không có ${indexing['name']} nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is BookmarkPostLoadedState) {
              return Column(
                children: [
                  Column(
                      children: state.postUsers.resultList
                          .map((e) {
                        return PostFeedItem(
                            postAggregation: e);
                      }).toList()),
                  Pagination(
                    path: indexing['path'] ?? '',
                    totalItem: state.postUsers.count,
                    params: widget.params,
                    selectedPage: widget.page,
                  )
                ],
              );
            } else if (state is BookmarkLoadErrorState) {
              return Container(
                alignment: Alignment.center,
                child:
                Text(state.message, style: const TextStyle(fontSize: 16)),
              );
            }

            return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}