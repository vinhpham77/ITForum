part of 'post_bloc.dart';

@immutable
sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

final class LoadPostsEvent extends PostEvent {
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