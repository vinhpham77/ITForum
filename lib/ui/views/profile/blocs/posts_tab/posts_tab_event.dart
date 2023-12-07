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

final class ConfirmDeleteEvent extends PostsTabEvent {
  final PostAggregation postUser;

  const ConfirmDeleteEvent({required this.postUser});

  @override
  List<Object?> get props => [postUser];
}

final class CancelDeleteEvent extends PostsTabEvent {}