import 'package:cay_khe/models/post_aggregation.dart';
import 'package:cay_khe/models/result_count.dart';
import 'package:cay_khe/repositories/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/message_from_exception.dart';

part 'posts_tab_event.dart';

part 'posts_tab_state.dart';

class PostsTabBloc extends Bloc<PostsTabEvent, PostsTabState> {
  final PostRepository _postRepository;

  PostsTabBloc({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(PostsInitialState()) {
    on<LoadPostsEvent>(_loadPosts);
    on<ConfirmDeleteEvent>(_confirmDelete);
  }

  Future<void> _loadPosts(
      LoadPostsEvent event, Emitter<PostsTabState> emit) async {
    try {
      Response<dynamic> response = await _postRepository.getByUser(
        event.username,
        page: event.page,
        limit: event.limit,
        isQuestion: event.isQuestion,
      );

      ResultCount<PostAggregation> postUsers =
          ResultCount.fromJson(response.data, PostAggregation.fromJson);

      if (postUsers.resultList.isEmpty) {
        emit(PostsEmptyState());
      } else {
        emit(PostsLoadedState(postUsers: postUsers));
      }
    } catch (error) {
      emit(const PostsLoadErrorState(
          message: "Có lỗi xảy ra. Vui lòng thử lại sau!"));
    }
  }

  void _confirmDelete(
      ConfirmDeleteEvent event, Emitter<PostsTabState> emit) async {
    try {
      await _postRepository.delete(event.postUser.id!);
      emit(PostsDeleteSuccessState(postUser: event.postUser));
    } catch (error) {
      String message = getMessageFromException(error);
      emit(PostsTabErrorState(message: message, postUsers: event.postUsers));
    }
  }
}
