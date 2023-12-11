import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/user.dart';
import '../../../../../repositories/follow_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final FollowRepository _followRepository;

  ProfileBloc(
      {required UserRepository userRepository,
      required FollowRepository followRepository})
      : _userRepository = userRepository,
        _followRepository = followRepository,
        super(ProfileInitialState()) {
    on<LoadProfileEvent>(_loadProfile);
    on<FollowEvent>(_follow);
    on<UnfollowEvent>(_unfollow);
  }

  Future<void> _loadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      Response<dynamic> response =
          await _userRepository.getUser(event.username);
      User user = User.fromJson(response.data);

      bool isFollowing = false;
      if (JwtPayload.sub != null && JwtPayload.sub != user.username) {
        Response<dynamic> isFollowingResponse =
            await _followRepository.isFollowing(user.username);
        isFollowing = isFollowingResponse.data;
      }

      emit(ProfileLoadedState(user: user, isFollowing: isFollowing));
    } catch (error) {
      if (error is DioException && error.response != null && error.response!.statusCode == 404) {
        emit(ProfileNotFoundState(
            message: 'Không tìm thấy người dùng @${event.username}!'));
        return;
      }

      String message = getMessageFromException(error);
      emit(ProfileLoadErrorState(message: message));
    }
  }

  Future<void> _follow(FollowEvent event, Emitter<ProfileState> emit) async {
    try {
      await _followRepository.follow(event.user.username);

      emit(ProfileLoadedState(
          user: event.user, isFollowing: true));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(ProfileCommonErrorState(
          user: event.user, isFollowing: event.isFollowing, message: message));
    }
  }

  Future<void> _unfollow(UnfollowEvent event, Emitter<ProfileState> emit) async {
    try {
      await _followRepository.unfollow(event.user.username);

      emit(ProfileLoadedState(
          user: event.user, isFollowing: false));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(ProfileCommonErrorState(
          user: event.user, isFollowing: event.isFollowing, message: message));
    }
  }
}
