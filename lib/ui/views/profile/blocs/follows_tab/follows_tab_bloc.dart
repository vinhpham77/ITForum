import 'package:cay_khe/dtos/user_metrics.dart';
import 'package:cay_khe/repositories/follow_repository.dart';
import 'package:cay_khe/ui/common/utils/index.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/result_count.dart';
import '../../../../../repositories/user_repository.dart';

part 'follows_tab_event.dart';

part 'follows_tab_state.dart';

class FollowsTabBloc extends Bloc<FollowsTabEvent, FollowsTabState> {
  final UserRepository _userRepository;

  FollowsTabBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const FollowsTabInitialState()) {
    on<LoadFollowsEvent>(_loadUserMetrics);
  }

  Future<void> _loadUserMetrics(
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

      final userMetricsList = ResultCount<UserMetrics>.fromJson(
        response.data,
        (json) => UserMetrics.fromJson(json),
      );

      emit(FollowsLoadedState(userMetricsList: userMetricsList));
    } on Exception catch (e) {
      String message = getMessageFromException(e);
      emit(FollowsLoadErrorState(message: message));
    }
  }

}
