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

final class FollowsEmptyState extends FollowsSubState {
  const FollowsEmptyState(
      {required super.userStatsList});
}

@immutable
sealed class FollowsSubState extends FollowsTabState {
  final ResultCount<UserStats> userStatsList;

  const FollowsSubState({required this.userStatsList});

  @override
  List<Object> get props => [userStatsList];
}

final class FollowsLoadedState extends FollowsSubState {
  const FollowsLoadedState(
      {required super.userStatsList});
}

final class FollowsLoadErrorState extends FollowsTabState {
  final String message;

  const FollowsLoadErrorState({required this.message});

  @override
  List<Object> get props => [message];
}