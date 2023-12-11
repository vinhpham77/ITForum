import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/profile/blocs/posts_tab/posts_tab_provider.dart';
import 'package:cay_khe/ui/views/profile/widgets/posts_tab/post_tab_item.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/pagination_states.dart';
import '../../../../widgets/pagination2.dart';
import '../../blocs/posts_tab/posts_tab_bloc.dart';

class PostsTab extends StatelessWidget {
  final String username;
  final int page;
  final int limit;
  final bool isQuestion;

  const PostsTab(
      {super.key,
      required this.username,
      required this.page,
      required this.limit,
      required this.isQuestion});

  Map<String, String> get target => isQuestion
      ? {"name": 'câu hỏi', "object": "questions"}
      : {"name": 'bài viết', "object": "posts"};

  @override
  Widget build(BuildContext context) {
    return PostsTabBlocProvider(
      username: username,
      page: page,
      limit: limit,
      isQuestion: isQuestion,
      child: BlocListener<PostsTabBloc, PostsTabState>(
        listener: (context, state) {
          if (state is PostsDeleteSuccessState) {
            appRouter.pop();
            showTopRightSnackBar(
              context,
              "Xoá ${target['name']} ${state.postUser.title} thành công!",
              NotifyType.success,
            );
            context.read<PostsTabBloc>().add(LoadPostsEvent(
                  username: username,
                  page: page,
                  limit: limit,
                  isQuestion: isQuestion,
                ));
          } else if (state is PostsTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<PostsTabBloc, PostsTabState>(
          builder: (context, state) {
            if (state is PostsEmptyState) {
              return buildSimpleContainer(
                child: Text(
                  "Không có ${target['name']} nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is PostsLoadedState) {
              return Column(
                children: [
                  buildPostList(context, state.postUsers),
                  buildPagination(state.postUsers),
                ],
              );
            } else if (state is PostsLoadErrorState) {
              return buildSimpleContainer(
                child:
                    Text(state.message, style: const TextStyle(fontSize: 16)),
              );
            }

            return buildSimpleContainer(
                child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Container buildSimpleContainer({required Widget child}) => Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: child);

  Pagination2 buildPagination(ResultCount<PostAggregation> postUsers) {
    return Pagination2(
        pagingStates: PaginationStates(
            count: postUsers.count,
            limit: limit,
            currentPage: page,
            range: 2,
            path: "/profile/$username/${target['object']}",
            params: {}));
  }

  Padding buildPostList(BuildContext context, ResultCount<PostAggregation> postUsers) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Column(
        children: [
          for (var postUser in postUsers.resultList) buildOneRow(context, postUser),
        ],
      ),
    );
  }

  Row buildOneRow(BuildContext context, PostAggregation postUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            transform: Matrix4.translationValues(-8.0, 0, 0),
            child: PostTabItem(postUser: postUser),
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
            onPressed: () => showDeleteConfirmationDialog(context, postUser),
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
      BuildContext context, PostAggregation postUser) async {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Bạn có chắc chắn muốn xoá ${target['name']} "${postUser.title}" không?'),
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
              context
                  .read<PostsTabBloc>()
                  .add(ConfirmDeleteEvent(postUser: postUser));
            },
          ),
        ],
      ),
    );
  }
}
