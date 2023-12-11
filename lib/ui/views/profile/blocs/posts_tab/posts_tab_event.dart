part of 'posts_tab_bloc.dart';

@immutable
sealed class PostsTabEvent extends Equatable {
  const PostsTabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPostsEvent extends PostsTabEvent {
  final String username;
  final int page;
  final int limit;
  final bool isQuestion;

  const LoadPostsEvent({
    required this.username,
    required this.page,
    required this.limit,
    required this.isQuestion,
  });

  @override
  List<Object?> get props => [username, page, limit, isQuestion];
}

final class PostsTabSubEvent extends PostsTabEvent {
  final ResultCount<PostAggregation> postUsers;

  const PostsTabSubEvent({required this.postUsers});

  @override
  List<Object?> get props => [postUsers];
}

final class ConfirmDeleteEvent extends PostsTabSubEvent {
  final PostAggregation postUser;

  const ConfirmDeleteEvent({
    required this.postUser,
    required super.postUsers,
  });

  @override
  List<Object?> get props => [postUser, postUsers];
}
