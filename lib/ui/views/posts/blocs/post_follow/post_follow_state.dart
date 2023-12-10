part of 'post_follow_bloc.dart';

@immutable
sealed class PostFollowState extends Equatable {
  const PostFollowState();

  @override
  List<Object?> get props => [];
}

final class PostFollowInitialState extends PostFollowState {}

final class PostFollowEmptyState extends PostFollowState {}

final class PostFollowLoadedState extends PostFollowState {
  final ResultCount<PostAggregation> postUsers;

  const PostFollowLoadedState({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class PostFollowTabErrorState extends PostFollowState {
  final String message;

  const PostFollowTabErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class PostFollowLoadErrorState extends PostFollowState {
  final String message;

  const PostFollowLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}