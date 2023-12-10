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

  const ProfileSubState({required this.user, required this.isFollowing});

  @override
  List<Object?> get props => [user, isFollowing];
}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadedState extends ProfileSubState {
  const ProfileLoadedState({required super.user, required super.isFollowing});
}

final class ProfileFollowedState extends ProfileSubState {
  const ProfileFollowedState({required super.user, required super.isFollowing});
}

final class ProfileUnfollowedState extends ProfileSubState {
  const ProfileUnfollowedState(
      {required super.user, required super.isFollowing});
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
      {required super.user, required super.isFollowing, required this.message});

  @override
  List<Object?> get props => [super.user, super.isFollowing, message];
}
