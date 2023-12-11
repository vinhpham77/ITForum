part of 'follow_item_bloc.dart';

@immutable
sealed class FollowItemEvent extends Equatable {
  const FollowItemEvent();

  @override
  List<Object> get props => [];
}

@immutable
sealed class FollowItemSubEvent extends FollowItemEvent {
  final String username;
  final bool isFollowed;

  const FollowItemSubEvent({required this.username, required this.isFollowed});

  @override
  List<Object> get props => [username, isFollowed];
}

final class FollowEvent extends FollowItemSubEvent {
  const FollowEvent({required super.isFollowed, required super.username});
}

final class UnfollowEvent extends FollowItemSubEvent {
  const UnfollowEvent({required super.isFollowed, required super.username});
}
