import 'package:cay_khe/dtos/bookmark_item.dart';
import 'package:cay_khe/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/result_count.dart';
import '../../../../../models/user.dart';
import '../../../../../repositories/bookmark_repository.dart';
import '../../../../common/utils/message_from_exception.dart';

part 'personal_tab_event.dart';

part 'personal_tab_state.dart';

class PersonalTabBloc extends Bloc<PersonalTabEvent, PersonalTabState> {
  final UserRepository _userRepository;

  PersonalTabBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitialState()) {
    on<LoadUserEvent>(_loadUser);
  }

  Future<void> _loadUser(
      LoadUserEvent event, Emitter<PersonalTabState> emit) async {
    try {
      late Response<dynamic> response;
      response = await _userRepository.get(event.username);
      User user = User.fromJson(response.data);

      emit(UserLoadedState(user: user));
    } catch (error) {
      emit(const UserLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

}
