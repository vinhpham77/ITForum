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
  final bool isPostBookmarks;

  const PersonalTabSubEvent(
      {required this.user, required this.isPostBookmarks});

  @override
  List<Object?> get props => [user, isPostBookmarks];
}
