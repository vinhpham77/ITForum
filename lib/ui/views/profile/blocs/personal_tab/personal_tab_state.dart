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

  const PersonalTabSubState({required this.user});


  @override
  List<Object?> get props => [user];
}

final class UserLoadedState extends PersonalTabSubState {
  const UserLoadedState({required super.user});
}

final class PersonalTabErrorState extends PersonalTabSubState {
  final String message;

  const PersonalTabErrorState(
      {required super.user, required this.message});

  @override
  List<Object?> get props => [super.user, message];
}

final class UserLoadErrorState extends PersonalTabState {
  final String message;

  const UserLoadErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
