part of 'follows_tab_bloc.dart';

@immutable
sealed class FollowsTabEvent extends Equatable {
  const FollowsTabEvent();

  @override
  List<Object> get props => [];
}

@immutable
sealed class FollowsSubEvent extends FollowsTabEvent {
  final ResultCount<UserMetrics> userMetricsList;

  const FollowsSubEvent({required this.userMetricsList});

  @override
  List<Object> get props => [userMetricsList];
}

final class LoadFollowsEvent extends FollowsTabEvent {
  final String username;
  final int page;
  final int limit;
  final bool isFollowed;

  const LoadFollowsEvent({
    required this.username,
    required this.page,
    required this.limit,
    required this.isFollowed,
  });

  @override
  List<Object> get props => [username, page, limit, isFollowed];
}

final class LoadFollowsErrorEvent extends FollowsTabEvent {
  final String message;

  const LoadFollowsErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}
