part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final User user;

  const ProfileLoadedState({required this.user});

  @override
  List<Object?> get props => [user];
}

final class ProfileErrorState extends ProfileState {
  final String message;

  const ProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class ProfileNotFoundState extends ProfileState {
  final String message;

  const ProfileNotFoundState({required this.message});

  @override
  List<Object?> get props => [message];
}