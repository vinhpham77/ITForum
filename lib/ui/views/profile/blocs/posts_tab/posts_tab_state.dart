part of 'posts_tab_bloc.dart';

@immutable
sealed class PostsTabState extends Equatable {
  const PostsTabState();

  @override
  List<Object?> get props => [];
}

final class PostsInitialState extends PostsTabState {}

final class PostsEmptyState extends PostsTabState {}

@immutable
sealed class PostsSubState extends PostsTabState {
  final ResultCount<PostAggregation> postUsers;

  const PostsSubState({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class PostsLoadedState extends PostsSubState {
  const PostsLoadedState({required super.postUsers});
}

final class PostsDeleteSuccessState extends PostsTabState {
  final PostAggregation postUser;

  const PostsDeleteSuccessState({required this.postUser});

  @override
  List<Object?> get props => [postUser];
}

final class PostsTabErrorState extends PostsSubState {
  final String message;

  const PostsTabErrorState({required this.message, required super.postUsers});

  @override
  List<Object?> get props => [message, super.postUsers];
}

final class PostsLoadErrorState extends PostsTabState {
  final String message;

  const PostsLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
