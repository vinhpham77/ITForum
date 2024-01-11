import 'package:cay_khe/dtos/series_user.dart';
import 'package:cay_khe/ui/views/profile/blocs/series_tab/series_tab_provider.dart';
import 'package:cay_khe/ui/views/profile/widgets/series_tab/series_tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/jwt_payload.dart';
import '../../../../../dtos/notify_type.dart';
import '../../../../../dtos/pagination_states.dart';
import '../../../../widgets/notification.dart';
import '../../../../widgets/pagination2.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/series_tab/series_tab_bloc.dart';

class SeriesTab extends StatelessWidget {
  final String username;
  final int page;
  final int limit;

  const SeriesTab(
      {super.key,
      required this.username,
      required this.page,
      required this.limit});

  @override
  Widget build(BuildContext context) {
    return SeriesTabBlocProvider(
      username: username,
      page: page,
      limit: limit,
      child: BlocListener<SeriesTabBloc, SeriesTabState>(
        listener: (context, state) {
          if (state is SeriesDeleteSuccessState) {
            showTopRightSnackBar(
              context,
              "Xoá series \"${state.seriesUser.title}\" thành công!",
              NotifyType.success,
            );

            final ProfileBloc profileBloc = context.read<ProfileBloc>();
            final profileState = profileBloc.state as ProfileSubState;

            profileBloc.add(DecreaseSeriesCountEvent(
              isFollowing: profileState.isFollowing,
              profileStats: profileState.profileStats,
              tagCounts: profileState.tagCounts,
              user: profileState.user,
            ));

            context.read<SeriesTabBloc>().add(
                LoadSeriesEvent(username: username, page: page, limit: limit));
          } else if (state is SeriesDeleteErrorState) {
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
          } else if (state is SeriesTabErrorState) {
            showTopRightSnackBar(
              context,
              state.message,
              NotifyType.error,
            );
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
          } else if (state is SeriesSubState) {
            return Column(
              children: [
                buildSeriesList(context, state),
                buildPagination(state),
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

  Padding buildSeriesList(BuildContext context, SeriesSubState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Column(
        children: [
          for (var seriesPost in state.seriesUsers.resultList)
            buildOneRow(context, seriesPost, state),
        ],
      ),
    );
  }

  Row buildOneRow(
      BuildContext context, SeriesUser seriesUser, SeriesSubState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            transform: Matrix4.translationValues(-8.0, 0, 0),
            child: SeriesTabItem(seriesUser: seriesUser),
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
            onPressed: () =>
                showDeleteConfirmationDialog(context, seriesUser, state),
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
      BuildContext context, SeriesUser seriesUser, SeriesSubState state) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Xác nhận'),
            onPressed: () {
              context.read<SeriesTabBloc>().add(ConfirmDeleteEvent(
                    seriesUser: seriesUser,
                    seriesUsers: state.seriesUsers,
                  ));
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  Pagination2 buildPagination(SeriesSubState state) {
    return Pagination2(
        pagingStates: PaginationStates(
            count: state.seriesUsers.count,
            limit: limit,
            currentPage: page,
            range: 2,
            path: "/profile/$username/series",
            params: {}));
  }
}
