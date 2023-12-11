import 'package:cay_khe/ui/views/profile/blocs/series_tab/series_tab_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/series_repository.dart';

class SeriesTabBlocProvider extends StatelessWidget {
  final Widget child;
  final String username;
  final int page;
  final int limit;

  const SeriesTabBlocProvider(
      {super.key,
      required this.child,
      required this.username,
      required this.page,
      required this.limit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SeriesTabBloc>(
      create: (context) {
        final bloc = SeriesTabBloc(seriesRepository: SeriesRepository());
        bloc.add(LoadSeriesEvent(
            username: username,
            page: page,
            limit: limit));
        return bloc;
      },
      child: child,
    );
  }
}
