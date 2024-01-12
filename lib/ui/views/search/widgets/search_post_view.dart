import 'package:cay_khe/ui/views/search/blocs/search_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dtos/notify_type.dart';
import '../../../widgets/notification.dart';
import '../../../widgets/pagination.dart';
import '../../posts/widgets/post_feed_item.dart';

class SearchPostView extends StatefulWidget {
  const SearchPostView({super.key, required this.params, required this.page});

  final Map<String, String> params;
  final int page;

  @override
  State<SearchPostView> createState() => _SearchPostViewState();
}

class _SearchPostViewState extends State<SearchPostView> {
  late SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc();
    loadPost();
  }

  @override
  void didUpdateWidget(SearchPostView oldWidget) {

    super.didUpdateWidget(oldWidget);
    loadPost();

  }

  void loadPost() {
    String searchStr = widget.params['searchContent'] ?? "";
    int index = searchStr.indexOf(':');
    String searchField = "";
    if (index != -1) {
      searchField = searchStr.substring(0, index);
      searchStr = searchStr.substring(index + 1);
    }

    _bloc..add(LoadPostsEvent(
        fieldSearch: searchField,
        searchContent: searchStr,
        sort: widget.params['sort'] ?? 'DESC',
        sortField: widget.params['sortField'] ?? 'updatedAt',
        page: widget.params['page'] ?? '1',
        limit: int.parse(widget.params['limit'] ?? "10")
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
      child: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is FollowTabErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is FollowEmptyState) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Không có bài viết nào nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is PostLoadedState) {
              return Column(
                children: [
                  Column(
                      children: state.posts.resultList
                          .map((e) {
                        return PostFeedItem(
                            postAggregation: e);
                      }).toList()),
                  Pagination(
                    path: "/viewsearch",
                    totalItem: state.posts.count,
                    params: widget.params,
                    selectedPage: int.parse(widget.params['page'] ?? '1'),
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