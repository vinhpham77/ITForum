part of 'follows_tab_bloc.dart';

@immutable
sealed class FollowsTabState extends Equatable {
  const FollowsTabState();

  @override
  List<Object> get props => [];
}

final class FollowsTabInitialState extends FollowsTabState {
  const FollowsTabInitialState();
}

final class FollowsEmptyState extends FollowsTabState {}

@immutable
sealed class FollowsSubState extends FollowsTabState {
  final ResultCount<UserMetrics> userMetricsList;

  const FollowsSubState({required this.userMetricsList});

  @override
  List<Object> get props => [userMetricsList];
}

final class FollowsLoadedState extends FollowsSubState {
  const FollowsLoadedState(
      {required super.userMetricsList});
}

final class FollowsLoadErrorState extends FollowsTabState {
  final String message;

  const FollowsLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}