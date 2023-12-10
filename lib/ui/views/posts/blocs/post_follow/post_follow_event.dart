part of 'post_follow_bloc.dart';

@immutable
sealed class PostFollowEvent extends Equatable {
  const PostFollowEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPostsEvent extends PostFollowEvent {
  final int page;
  final int limit;
  final isQuestion;

  const LoadPostsEvent({
    required this.page,
    required this.limit,
    this.isQuestion = false
  });

  @override
  List<Object?> get props => [page, limit, isQuestion];
}