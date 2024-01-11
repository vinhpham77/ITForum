part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

@immutable
sealed class ProfileSubState extends ProfileState {
  final User user;
  final bool isFollowing;
  final List<TagCount> tagCounts;
  final ProfileStats? profileStats;

  const ProfileSubState(
      {required this.user,
        required this.isFollowing,
        required this.tagCounts,
        required this.profileStats});

  @override
  List<Object?> get props => [user, isFollowing];
}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadedState extends ProfileSubState {
  const ProfileLoadedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class ProfileStatsLoadedState extends ProfileSubState {
  const ProfileStatsLoadedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class ProfileAllLoadedState extends ProfileSubState {
  const ProfileAllLoadedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class ProfileFollowWaitingState extends ProfileSubState {
  const ProfileFollowWaitingState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class SeriesCountDecreasedState extends ProfileSubState {
  const SeriesCountDecreasedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class ProfileFollowedState extends ProfileSubState {
  const ProfileFollowedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class ProfileUnfollowedState extends ProfileSubState {
  const ProfileUnfollowedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class ProfileItemUnfollowedState extends ProfileSubState {
  const ProfileItemUnfollowedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class ProfileItemFollowedState extends ProfileSubState {
  const ProfileItemFollowedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class PostsCountDecreasedState extends ProfileSubState {
  const PostsCountDecreasedState(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

@immutable
sealed class ProfileErrorState extends ProfileState {
  final String message;

  const ProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class ProfileNotFoundState extends ProfileErrorState {
  const ProfileNotFoundState({required super.message});
}

final class ProfileLoadErrorState extends ProfileErrorState {
  const ProfileLoadErrorState({required super.message});
}

final class ProfileCommonErrorState extends ProfileSubState {
  final String message;

  const ProfileCommonErrorState(
      {required super.user,
        required super.isFollowing,
        required this.message,
        required super.tagCounts,
        required super.profileStats});

  @override
  List<Object?> get props => [super.user, super.isFollowing, message];
}
