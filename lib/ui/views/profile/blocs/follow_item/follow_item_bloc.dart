import 'package:cay_khe/ui/common/utils/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../repositories/follow_repository.dart';

part 'follow_item_event.dart';

part 'follow_item_state.dart';

class FollowItemBloc extends Bloc<FollowItemEvent, FollowItemState> {
  final FollowRepository _followRepository;
  final bool isFollowing;

  FollowItemBloc(
      {required this.isFollowing, required FollowRepository followRepository})
      : _followRepository = followRepository,
        super(FollowItemInitialState(isFollowing: isFollowing)) {
    on<HandleFollowItemEvent>(_follow);
    on<HandleUnfollowItemEvent>(_unfollow);
  }

  Future<void> _follow(
      HandleFollowItemEvent event,
      Emitter<FollowItemState> emit,
      ) async {
    try {
      emit(FollowOperationWaitingState(isFollowing: event.isFollowed));

      await _followRepository.follow(event.username);
      emit(const FollowSuccessState(isFollowing: true));
    } on Exception catch (e) {
      String message = getMessageFromException(e);
      emit(FollowOperationErrorState(
          message: message, isFollowing: isFollowing));
    }
  }

  Future<void> _unfollow(
      HandleUnfollowItemEvent event,
      Emitter<FollowItemState> emit,
      ) async {
    try {
      emit(FollowOperationWaitingState(isFollowing: event.isFollowed));
      await _followRepository.unfollow(event.username);
      emit(const UnfollowSuccessState(isFollowing: false));
    } on Exception catch (e) {
      String message = getMessageFromException(e);
      emit(FollowOperationErrorState(
          message: message, isFollowing: isFollowing));
    }
  }
}
