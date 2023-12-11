import 'package:flutter/material.dart';

import '../../dtos/pagination_states.dart';
import '../router.dart';

class Pagination2 extends StatelessWidget {
  final PaginationStates pagingStates;

  const Pagination2({super.key, required this.pagingStates});

  @override
  Widget build(BuildContext context) {
    int totalPages = (pagingStates.count / pagingStates.limit).ceil();
    int min = pagingStates.currentPage - pagingStates.range;
    int max = pagingStates.currentPage + pagingStates.range;

    min = min < 1 ? 1 : min;
    max = max > totalPages ? totalPages : max;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: totalPages <= 1
            ? Container()
            : _buildPaginationRow(context, min, max, totalPages),
      ),
    );
  }

  Row _buildPaginationRow(BuildContext context, int min, int max, int totalPages) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pagingStates.currentPage > 1)
            buildPaginationButton(
              context,
              route: pagingStates.path,
              params: convertParams(pagingStates.currentPage - 1),
              child: const Icon(Icons.chevron_left),
            ),
          for (int i = min; i <= max; i++)
            if (i == pagingStates.currentPage)
              buildPaginationButton(
                context,
                child: Text(i.toString()),
              )
            else
              buildPaginationButton(
                context,
                route: pagingStates.path,
                params: convertParams(i),
                child: Text(i.toString()),
              ),
          if (pagingStates.currentPage < totalPages)
            buildPaginationButton(
              context,
              route: pagingStates.path,
              params: convertParams(pagingStates.currentPage + 1),
              child: const Icon(Icons.chevron_right),
            ),
        ],
      );
  }

  buildPaginationButton(BuildContext context,
      {required Widget child, String? route, Map<String, dynamic>? params}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: OutlinedButton(
          onPressed: (route == null)
              ? null
              : () => appRouter.push(route, extra: params),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                color: route != null
                    ? Theme.of(context).primaryColor
                    : Colors.blueGrey,
                width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.only(
                top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
          ),
          child: child),
    );
  }

  Map<String, dynamic> convertParams(int page) {
    Map<String, dynamic> params = Map.from(pagingStates.params);
    params['page'] = page;

    return params;
  }
}
