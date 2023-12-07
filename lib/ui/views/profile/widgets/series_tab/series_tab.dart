import 'package:cay_khe/dtos/series_user.dart';
import 'package:cay_khe/ui/views/profile/widgets/series_tab/series_tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/notify_type.dart';
import '../../../../../dtos/pagination_states.dart';
import '../../../../../models/result_count.dart';
import '../../../../router.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination2.dart';
import '../../blocs/series_tab/series_tab_bloc.dart';

class SeriesTab extends StatefulWidget {
  final String username;
  final int page;
  final int limit;

  const SeriesTab(
      {super.key,
      required this.username,
      required this.page,
      required this.limit});

  @override
  State<SeriesTab> createState() => _TabPageState();
}

class _TabPageState extends State<SeriesTab> {
  late SeriesTabBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SeriesTabBloc()
      ..add(LoadSeriesEvent(
          username: widget.username, page: widget.page, limit: widget.limit));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<SeriesTabBloc, SeriesTabState>(
        listener: (context, state) {
          if (state is SeriesDeleteSuccessState) {
            appRouter.pop();
            showTopRightSnackBar(
              context,
              "Xoá series ${state.seriesUser.title} thành công!",
              NotifyType.success,
            );
            _bloc.add(LoadSeriesEvent(
              username: widget.username,
              page: widget.page,
              limit: widget.limit,
            ));
          } else if (state is SeriesTabErrorState) {
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          } else if (state is SeriesDialogCanceledState) {
            appRouter.pop();
          }
        },
        child: BlocBuilder<SeriesTabBloc, SeriesTabState>(
            builder: (context, state) {
          if (state is SeriesEmptyState) {
            return buildSimpleContainer(
              child: const Text(
                "Không có series nào!",
                style: TextStyle(fontSize: 16),
              ),
            );
          } else if (state is SeriesLoadedState) {
            return Column(
              children: [
                buildSeriesList(state.seriesUsers),
                buildPagination(state.seriesUsers),
              ],
            );
          } else if (state is SeriesLoadErrorState) {
            return buildSimpleContainer(
              child: Text(state.message, style: const TextStyle(fontSize: 16)),
            );
          }

          return buildSimpleContainer(child: const CircularProgressIndicator());
        }),
      ),
    );
  }

  Container buildSimpleContainer({required Widget child}) => Container(
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: child);

  Padding buildSeriesList(ResultCount<SeriesUser> seriesUsers) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Column(
        children: [
          for (var postUser in seriesUsers.resultList) buildOneRow(postUser),
        ],
      ),
    );
  }

  Row buildOneRow(SeriesUser seriesUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            transform: Matrix4.translationValues(-8.0, 0, 0),
            child: SeriesTabItem(seriesUser: seriesUser),
          ),
        ),
        if (widget.username == JwtPayload.sub)
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
            onPressed: () => showDeleteConfirmationDialog(context, seriesUser),
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
      BuildContext context, SeriesUser seriesUser) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Bạn có chắc chắn muốn xoá series "${seriesUser.title}" không?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              _bloc.add(CancelDeleteEvent());
            },
          ),
          TextButton(
            child: const Text('Xác nhận'),
            onPressed: () {
              _bloc.add(ConfirmDeleteEvent(seriesUser: seriesUser));
            },
          ),
        ],
      ),
    );
  }

  Pagination2 buildPagination(ResultCount<SeriesUser> seriesUser) {
    return Pagination2(
        pagingStates: PaginationStates(
            count: seriesUser.count,
            limit: widget.limit,
            currentPage: widget.page,
            range: 2,
            path: "/profile/${widget.username}/series",
            params: {}));
  }
}
