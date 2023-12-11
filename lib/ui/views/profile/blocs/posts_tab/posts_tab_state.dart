part of 'posts_tab_bloc.dart';

@immutable
sealed class PostsTabState extends Equatable {
  const PostsTabState();

  @override
  List<Object?> get props => [];
}

final class PostsInitialState extends PostsTabState {}

final class PostsEmptyState extends PostsTabState {}

final class PostsLoadedState extends PostsTabState {
  final ResultCount<PostAggregation> postUsers;

  const PostsLoadedState({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class PostsDeleteSuccessState extends PostsTabState {
  final PostAggregation postUser;

  const PostsDeleteSuccessState({required this.postUser});

  @override
  List<Object?> get props => [postUser];
}

final class PostsTabErrorState extends PostsTabState {
  final String message;

  const PostsTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class PostsLoadErrorState extends PostsTabState {
  final String message;

  const PostsLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}