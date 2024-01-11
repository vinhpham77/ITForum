part of 'follow_item_bloc.dart';

@immutable
sealed class FollowItemState extends Equatable {
  const FollowItemState();

  @override
  List<Object> get props => [];
}

final class FollowItemInitialState extends FollowItemSubState {
  const FollowItemInitialState({required super.isFollowing});
}

@immutable
sealed class FollowItemSubState extends FollowItemState {
  final bool isFollowing;

  const FollowItemSubState({required this.isFollowing});

  @override
  List<Object> get props => [isFollowing];
}

final class FollowItemSuccessState extends FollowItemSubState {
  const FollowItemSuccessState({required super.isFollowing});
}

final class FollowSuccessState extends FollowItemSubState {
  const FollowSuccessState({required super.isFollowing});
}

final class UnfollowSuccessState extends FollowItemSubState {
  const UnfollowSuccessState({required super.isFollowing});
}

final class FollowOperationErrorState extends FollowItemSubState {
  final String message;

  const FollowOperationErrorState({required this.message, required super.isFollowing});

  @override
  List<Object> get props => [message, isFollowing];
}

final class FollowOperationWaitingState extends FollowItemSubState {
  const FollowOperationWaitingState({required super.isFollowing});
}
