import 'package:cay_khe/ui/views/search/blocs/search_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dtos/notify_type.dart';
import '../../../widgets/notification.dart';
import '../../../widgets/pagination.dart';
import '../../posts/widgets/series_feed_item.dart';

class SearchSeriesView extends StatefulWidget {
  const SearchSeriesView({super.key, required this.params, required this.page});

  final Map<String, String> params;
  final int page;

  @override
  State<SearchSeriesView> createState() => _SearchSeriesViewState();
}

class _SearchSeriesViewState extends State<SearchSeriesView> {
  late SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc();
    loadPost();
  }

  @override
  void didUpdateWidget(SearchSeriesView oldWidget) {

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

    _bloc..add(LoadSeriesEvent(
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
                  "Không có series nào nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is SeriesLoadedState) {
              return Column(
                children: [
                  Column(
                      children: state.seriesPost.resultList
                          .map((e) {
                        return SeriesFeedItem(
                            seriesPost: e);
                      }).toList()),
                  Pagination(
                    path: "/viewsearchSeries",
                    totalItem: state.seriesPost.count,
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