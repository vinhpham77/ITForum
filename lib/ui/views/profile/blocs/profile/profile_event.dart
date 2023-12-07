part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProfileEvent extends ProfileEvent {
  final String username;

  const LoadProfileEvent({required this.username});

  @override
  List<Object> get props => [username];
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
