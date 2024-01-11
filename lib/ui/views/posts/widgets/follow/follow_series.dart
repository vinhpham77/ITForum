import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/notify_type.dart';
import '../../../../widgets/notification.dart';
import '../../blocs/post_follow/follow_bloc.dart';
import '../../../../widgets/pagination.dart';
import '../series_feed_item.dart';

class FollowSeries extends StatefulWidget {
  final int page;
  final int limit;
  final Map<String, String> params;

  const FollowSeries(
      {super.key,
        required this.page,
        required this.limit,
        required this.params
      });

  @override
  State<FollowSeries> createState() => _FollowSeriesState();
}

class _FollowSeriesState extends State<FollowSeries> {
  late FollowBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = FollowBloc()
      ..add(LoadSeriesFollowEvent(
        limit: widget.limit,
        page: widget.page,
      ));
  }

  @override
  void didUpdateWidget(FollowSeries oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bloc.add(LoadSeriesFollowEvent(
      limit: widget.limit,
      page: widget.page,
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
                  "Không có series nào!",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            } else if (state is SeriesFollowLoadedState) {
              return Column(
                children: [
                  Column(
                      children: state.seriesUser.resultList
                          .map((e) {
                        return SeriesFeedItem(
                            seriesPost: e);
                      }).toList()),
                  Pagination(
                    path: "viewfollow",
                    totalItem: state.seriesUser.count,
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