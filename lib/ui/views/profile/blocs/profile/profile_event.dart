part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

@immutable
sealed class ProfileSubEvent extends ProfileEvent {
  final User user;
  final bool isFollowing;

  const ProfileSubEvent({required this.user, required this.isFollowing});

  @override
  List<Object?> get props => [user, isFollowing];
}

final class LoadProfileEvent extends ProfileEvent {
final String username;

  const LoadProfileEvent({required this.username});

  @override
  List<Object?> get props => [username];
}

final class LoadTabStatesEvent extends ProfileEvent {
  final int selectedIndex;
  final Map<String, dynamic> tabs;

  const LoadTabStatesEvent({
    required this.selectedIndex,
    required this.tabs,
  });

  @override
  List<Object> get props => [selectedIndex, tabs];
}

final class FollowEvent extends ProfileSubEvent {
  const FollowEvent({required super.user, required super.isFollowing});
}

final class UnfollowEvent extends ProfileSubEvent {
  const UnfollowEvent({required super.user, required super.isFollowing});
}