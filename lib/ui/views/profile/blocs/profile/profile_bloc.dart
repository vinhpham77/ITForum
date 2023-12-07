import 'package:cay_khe/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/user.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository = UserRepository();

  ProfileBloc() : super(ProfileInitialState()) {
    on<LoadProfileEvent>(_loadProfile);
  }

  Future<void> _loadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      Response<dynamic> response =
          await _userRepository.getUser(event.username);
      User user = User.fromJson(response.data);
      emit(ProfileLoadedState(user: user));
    } catch (error) {

      if (error is DioException && error.response!.statusCode == 404) {
        emit(const ProfileNotFoundState(message: 'Không tìm thấy người dùng!'));
        return;
      }

      String message = getMessageFromException(error);
      emit(ProfileErrorState(message: message));
    }
  }
}
