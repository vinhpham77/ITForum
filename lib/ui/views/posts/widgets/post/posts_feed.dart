import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination.dart';
import '../../blocs/post/post_bloc.dart';
import '../post_feed_item.dart';


class PostsFeed extends StatefulWidget {
  final int page;
  final int limit;
  final bool isQuestion;
  final Map<String, String> params;

  const PostsFeed(
      {super.key,
        required this.page,
        required this.limit,
        required this.isQuestion,
        required this.params
      });

  @override
  State<PostsFeed> createState() => _PostsFeedState();
}

class _PostsFeedState extends State<PostsFeed> {
  late PostBloc _bloc;
  late Map<String, String> indexing = widget.isQuestion ? {'name' : 'hỏi đáp', 'path': '/viewquestion'} :
    {'name' : 'bài viết', 'path': '/viewposts'};

  @override
  void initState() {
    super.initState();
    _bloc = PostBloc()
      ..add(LoadPostsEvent(
          limit: widget.limit,
          page: widget.page,
          isQuestion: widget.isQuestion
      ));
  }

  @override
  void didUpdateWidget(PostsFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc..add(LoadPostsEvent(
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
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostsTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostsEmptyState) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Không có ${indexing['name']} nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is PostsLoadedState) {
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
            } else if (state is PostsLoadErrorState) {
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