import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repositories/post_repository.dart';
import '../../../../repositories/series_repository.dart';
import 'cu_series_bloc.dart';

class CuSeriesBlocProvider extends StatelessWidget {
  final Widget child;
  final String? id;

  const CuSeriesBlocProvider({super.key, required this.child, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final bloc = CuSeriesBloc(
            seriesRepository: SeriesRepository(),
            postRepository: PostRepository());
        if (id != null) {
          bloc.add(LoadSeriesEvent(id: id!));
        } else {
          bloc.add(InitEmptySeriesEvent());
        }
        return bloc;
      },
      child: child,
    );
  }
}
