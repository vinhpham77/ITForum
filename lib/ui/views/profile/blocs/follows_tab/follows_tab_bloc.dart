import 'package:cay_khe/ui/common/utils/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dtos/result_count.dart';
import '../../../../../dtos/user_stats.dart';
import '../../../../../repositories/user_repository.dart';

part 'follows_tab_event.dart';

part 'follows_tab_state.dart';

class FollowsTabBloc extends Bloc<FollowsTabEvent, FollowsTabState> {
  final UserRepository _userRepository;

  FollowsTabBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const FollowsTabInitialState()) {
    on<LoadFollowsEvent>(_loadUserStats);
  }

  Future<void> _loadUserStats(
      LoadFollowsEvent event,
      Emitter<FollowsTabState> emit,
      ) async {
    try {
      final response = await _userRepository.getFollows(
        username: event.username,
        page: event.page,
        limit: event.limit,
        isFollowed: event.isFollowed,
      );

      final userStatsList = ResultCount<UserStats>.fromJson(
        response.data,
            (json) => UserStats.fromJson(json),
      );

      emit(FollowsLoadedState(userStatsList: userStatsList));
      if (userStatsList.resultList.isEmpty) {
        emit(FollowsEmptyState(userStatsList: userStatsList));
      } else {
        emit(FollowsLoadedState(userStatsList: userStatsList));
      }
    } on Exception catch (e) {
      String message = getMessageFromException(e);
      emit(FollowsLoadErrorState(message: message));
    }
  }
}
