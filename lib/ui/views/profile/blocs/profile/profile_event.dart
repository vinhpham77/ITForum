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
  final List<TagCount> tagCounts;
  final ProfileStats? profileStats;

  const ProfileSubEvent(
      {required this.user,
        required this.isFollowing,
        required this.tagCounts,
        required this.profileStats});

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
  const FollowEvent(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class UnfollowEvent extends ProfileSubEvent {
  const UnfollowEvent(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class SuccessFollowItemEvent extends ProfileSubEvent {
  const SuccessFollowItemEvent(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class SuccessUnfollowItemEvent extends ProfileSubEvent {
  const SuccessUnfollowItemEvent(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class DecreaseSeriesCountEvent extends ProfileSubEvent {
  const DecreaseSeriesCountEvent(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats});
}

final class DecreasePostsCountEvent extends ProfileSubEvent {
  final PostAggregation postUser;

  const DecreasePostsCountEvent(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats,
        required this.postUser});

  @override
  List<Object?> get props => [postUser];
}

final class DecreaseBookmarksCountEvent extends ProfileSubEvent {
  final BookmarkItem bookmarkItem;

  const DecreaseBookmarksCountEvent(
      {required super.user,
        required super.isFollowing,
        required super.tagCounts,
        required super.profileStats,
        required this.bookmarkItem});

  @override
  List<Object?> get props => [bookmarkItem];
}