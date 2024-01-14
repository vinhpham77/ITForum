import 'package:cay_khe/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../api_config.dart';
import '../../../../../dtos/user_dto.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/image_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'personal_tab_event.dart';
part 'personal_tab_state.dart';

class PersonalTabBloc extends Bloc<PersonalTabEvent, PersonalTabState> {
  final UserRepository _userRepository;
  final ImageRepository _imageRepository;

  PersonalTabBloc(
      {required UserRepository userRepository,
      required ImageRepository imageRepository})
      : _userRepository = userRepository,
        _imageRepository = imageRepository,
        super(UserInitialState()) {
    on<LoadUserEvent>(_loadUser);
    on<ChangeAvatarEvent>(_changeAvatar);
    on<DeleteAvatarEvent>(_deleteAvatar);
    on<SwitchModeEvent>(_switchMode);
    on<ChangeGenderEvent>(_changeGender);
    on<UpdateProfileEvent>(_updateProfile);
  }

  Future<void> _loadUser(
      LoadUserEvent event, Emitter<PersonalTabState> emit) async {
    try {
      late Response<dynamic> response;
      response = await _userRepository.get(event.username);
      User user = User.fromJson(response.data);

      emit(UserLoadedState(user: user, isEditingMode: true));
    } catch (error) {
      emit(const UserLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  Future<void> _changeAvatar(
      ChangeAvatarEvent event, Emitter<PersonalTabState> emit) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      emit(AvatarChangingState(
          user: event.user, isEditingMode: event.isEditingMode));

      User user;
      if (image != null) {
        var response = await _imageRepository.upload(image);
        String avatarUrl =
            '${ApiConfig.baseUrl}/${ApiConfig.imagesEndpoint}/${response.data.toString()}';
        user = event.user.copyWith(avatarUrl: avatarUrl);
      } else {
        user = event.user;
      }

      emit(UserLoadedState(user: user, isEditingMode: event.isEditingMode));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(PersonalTabErrorState(
          message: message,
          user: event.user,
          isEditingMode: event.isEditingMode));
    }
  }

  void _deleteAvatar(
      DeleteAvatarEvent event, Emitter<PersonalTabState> emit) async {
    emit(AvatarChangingState(
        user: event.user, isEditingMode: event.isEditingMode));

    User user = event.user.copyWith();
    user.avatarUrl = null;

    emit(UserLoadedState(user: user, isEditingMode: event.isEditingMode));
  }

  void _switchMode(
      SwitchModeEvent event, Emitter<PersonalTabState> emit) async {
    emit(UserLoadedState(user: event.user, isEditingMode: event.isEditingMode));
  }

  void _changeGender(ChangeGenderEvent event, Emitter<PersonalTabState> emit) {
    User user = event.user.copyWith();
    user.gender = event.gender;

    emit(UserLoadedState(user: user, isEditingMode: event.isEditingMode));
  }

  Future<void> _updateProfile(
      UpdateProfileEvent event, Emitter<PersonalTabState> emit) async {
    try {
      emit(UserUpdatingState(
          user: event.user, isEditingMode: event.isEditingMode));

      var response =
          await _userRepository.update(event.user.username, event.newUser);
      User user = User.fromJson(response.data);

      emit(UserUpdatedState(user: user, isEditingMode: event.isEditingMode));
    } catch (error) {
      print(error.runtimeType);
      print(error);
      String message = getMessageFromException(error);
      emit(PersonalTabErrorState(
          message: message,
          user: event.user,
          isEditingMode: event.isEditingMode));
    }
  }
}
