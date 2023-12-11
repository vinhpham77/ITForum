part of 'series_tab_bloc.dart';

@immutable
sealed class SeriesTabState extends Equatable {
  const SeriesTabState();

  @override
  List<Object?> get props => [];
}

final class SeriesInitialState extends SeriesTabState {}

final class SeriesEmptyState extends SeriesTabState {}

@immutable
final class SeriesSubState extends SeriesTabState {
  final ResultCount<SeriesUser> seriesUsers;

  const SeriesSubState({
    required this.seriesUsers,
  });

  @override
  List<Object?> get props => [seriesUsers];
}

final class SeriesLoadedState extends SeriesSubState {
  const SeriesLoadedState({
    required super.seriesUsers,
  });
}

final class SeriesDeleteSuccessState extends SeriesTabState {
  final SeriesUser seriesUser;

  const SeriesDeleteSuccessState({required this.seriesUser});

  @override
  List<Object?> get props => [seriesUser];
}

@immutable
sealed class SeriesTabErrorState extends SeriesTabState {
  final String message;

  const SeriesTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SeriesDeleteErrorState extends SeriesSubState {
  final String message;

  const SeriesDeleteErrorState({
    required this.message,
    required super.seriesUsers,
  });

  @override
  List<Object?> get props => [message, super.seriesUsers];
}

final class SeriesLoadErrorState extends SeriesTabErrorState {
  const SeriesLoadErrorState({required super.message});
}
