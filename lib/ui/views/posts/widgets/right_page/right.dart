import 'package:cay_khe/ui/views/posts/widgets/right_page/right_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../widgets/notification.dart';
import '../../blocs/post/post_bloc.dart';


class Right extends StatefulWidget {
  final int page;
  final int limit;
  final bool isQuestion;

  const Right(
      {super.key,
        required this.page,
        required this.limit,
        required this.isQuestion
      });

  @override
  State<Right> createState() => _RightState();
}

class _RightState extends State<Right> {
  late PostBloc _bloc;
  late Map<String, String> indexing = widget.isQuestion ? {'title': 'BÀI VIẾT MỚI NHẤT', 'name' : 'bài viết'} :
  { 'title': 'CÂU HỎI MỚI NHẤT', 'name' : 'hỏi đáp'};

  @override
  void initState() {
    super.initState();
    _bloc = PostBloc()
      ..add(LoadPostsEvent(
          limit: widget.limit,
          page: widget.page,
          isQuestion: !widget.isQuestion
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    indexing['title'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.postUsers.resultList
                        .map((e) {
                      return RightItem(
                          postAggregation: e);
                    }).toList()),
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