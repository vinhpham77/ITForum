import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination.dart';
import '../../../profile/widgets/posts_tab/post_tab_item.dart';
import '../../blocs/post_follow/follow_bloc.dart';


class FollowPost extends StatefulWidget {
  final int page;
  final int limit;
  final bool isQuestion;
  final Map<String, String> params;

  const FollowPost(
      {super.key,
        required this.page,
        required this.limit,
        required this.isQuestion,
        required this.params
      });

  @override
  State<FollowPost> createState() => _FollowPostState();
}

class _FollowPostState extends State<FollowPost> {
  late FollowBloc _bloc;
  late Map<String, String> indexing = widget.isQuestion ? {'name' : 'hỏi đáp', 'path': '/viewquestionfollow'} :
  {'name' : 'bài viết', 'path': '/viewfollow'};

  @override
  void initState() {
    super.initState();
    _bloc = FollowBloc()
      ..add(LoadPostsFollowEvent(
          limit: widget.limit,
          page: widget.page,
          isQuestion: widget.isQuestion
      ));
  }

  @override
  void didUpdateWidget(FollowPost oldWidget) {

    super.didUpdateWidget(oldWidget);
    _bloc..add(LoadPostsFollowEvent(
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
      child: BlocListener<FollowBloc, FollowState>(
        listener: (context, state) {
          if (state is FollowTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<FollowBloc, FollowState>(
          builder: (context, state) {
            if (state is FollowEmptyState) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Không có ${indexing['name']} nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is PostFollowLoadedState) {
              return Column(
                children: [
                  Column(
                      children: state.postUsers.resultList
                          .map((e) {
                        return PostTabItem(
                            postUser: e);
                      }).toList()),
                  Pagination(
                    path: indexing['path'] ?? '',
                    totalItem: state.postUsers.count,
                    params: widget.params,
                    selectedPage: widget.page,
                  )
                ],
              );
            } else if (state is FollowLoadErrorState) {
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