part of 'bookmark_bloc.dart';

@immutable
sealed class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

final class BookmarkInitialState extends BookmarkState {}

final class BookmarkEmptyState extends BookmarkState {}

final class BookmarkPostLoadedState extends BookmarkState {
  final ResultCount<PostAggregation> postUsers;

  const BookmarkPostLoadedState({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class BookmarkSeriesLoadedState extends BookmarkState {
  final ResultCount<SeriesUser> seriesUser;

  const BookmarkSeriesLoadedState({required this.seriesUser});

  @override
  List<Object?> get props => [seriesUser];
}

final class BookmarkTabErrorState extends BookmarkState {
  final String message;

  const BookmarkTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class BookmarkLoadErrorState extends BookmarkState {
  final String message;

  const BookmarkLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}