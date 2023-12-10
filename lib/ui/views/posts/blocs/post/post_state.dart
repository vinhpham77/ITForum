part of 'post_bloc.dart';

@immutable
sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

final class PostsInitialState extends PostState {}

final class PostsEmptyState extends PostState {}

final class PostsLoadedState extends PostState {
  final ResultCount<PostAggregation> postUsers;

  const PostsLoadedState({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class PostsTabErrorState extends PostState {
  final String message;

  const PostsTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class PostsLoadErrorState extends PostState {
  final String message;

  const PostsLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}