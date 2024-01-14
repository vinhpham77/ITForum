part of 'personal_tab_bloc.dart';

@immutable
sealed class PersonalTabEvent extends Equatable {
  const PersonalTabEvent();

  @override
  List<Object?> get props => [];
}

final class LoadUserEvent extends PersonalTabEvent {
  final String username;

  const LoadUserEvent({required this.username});

  @override
  List<Object?> get props => [username];
}

final class PersonalTabSubEvent extends PersonalTabEvent {
  final User user;
  final bool isEditingMode;

  const PersonalTabSubEvent(
      {required this.user, required this.isEditingMode});

  @override
  List<Object?> get props => [user, isEditingMode];
}

final class SwitchModeEvent extends PersonalTabSubEvent {
  const SwitchModeEvent({required super.user, required super.isEditingMode});

  @override
  List<Object?> get props => [user, isEditingMode];
}

final class ChangeAvatarEvent extends PersonalTabSubEvent {
  const ChangeAvatarEvent(
      {required super.user, required super.isEditingMode});
}

final class DeleteAvatarEvent extends PersonalTabSubEvent {
  const DeleteAvatarEvent(
      {required super.user, required super.isEditingMode});
}

final class ChangeGenderEvent extends PersonalTabSubEvent {
  final bool? gender;

  const ChangeGenderEvent({required this.gender, required super.user, required super.isEditingMode});

  @override
  List<Object?> get props => [gender, super.user, super.isEditingMode];
}

final class UpdateProfileEvent extends PersonalTabSubEvent {
  final UserDTO newUser;

  const UpdateProfileEvent(
      {required this.newUser, required super.user, required super.isEditingMode});

  @override
  List<Object?> get props => [newUser, super.user, super.isEditingMode];
}