part of 'personal_tab_bloc.dart';

@immutable
sealed class PersonalTabState extends Equatable {
  const PersonalTabState();

  @override
  List<Object?> get props => [];
}

final class UserInitialState extends PersonalTabState {}

@immutable
sealed class PersonalTabSubState extends PersonalTabState {
  final User user;
  final bool isEditingMode;

  const PersonalTabSubState({required this.user, required this.isEditingMode});


  @override
  List<Object?> get props => [user, isEditingMode];
}

final class UserLoadedState extends PersonalTabSubState {
  const UserLoadedState({required super.user, required super.isEditingMode});
}

final class PersonalTabErrorState extends PersonalTabSubState {
  final String message;

  const PersonalTabErrorState(
      {required super.user, required this.message, required super.isEditingMode});

  @override
  List<Object?> get props => [super.user, message, super.isEditingMode];
}

final class UserLoadErrorState extends PersonalTabState {
  final String message;

  const UserLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AvatarChangedState extends PersonalTabSubState {
  const AvatarChangedState({required super.user, required super.isEditingMode});
}

final class AvatarChangingState extends PersonalTabSubState {
  const AvatarChangingState({required super.user, required super.isEditingMode});
}

final class UserUpdatingState extends PersonalTabSubState {
  const UserUpdatingState({required super.user, required super.isEditingMode});
}

final class UserUpdatedState extends PersonalTabSubState {
  const UserUpdatedState({required super.user, required super.isEditingMode});
}