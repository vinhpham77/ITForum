part of 'cu_post_bloc.dart';

@immutable
sealed class CuPostState extends Equatable {
  const CuPostState();

  @override
  List<Object?> get props => [];
}

@immutable
sealed class CuPostQuestionState extends CuPostState {
  final bool isQuestion;

  const CuPostQuestionState({required this.isQuestion});

  @override
  List<Object?> get props => [isQuestion];
}

final class CuPostInitState extends CuPostState {}

@immutable
sealed class CuPostSubState extends CuPostQuestionState {
  final Post? post;
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final bool isEditMode;

  const CuPostSubState({
    required this.isEditMode,
    required this.post,
    required this.selectedTags,
    required this.tags,
    required super.isQuestion,
  });

  @override
  List<Object?> get props =>
      [isEditMode, post, selectedTags, tags, super.isQuestion];
}

final class CuPostEmptyState extends CuPostSubState {
  const CuPostEmptyState(
      {super.isEditMode = true,
      super.post,
      super.selectedTags = const [],
      super.tags = const [],
      required super.isQuestion});
}

final class CuPostLoadedState extends CuPostSubState {
  const CuPostLoadedState({
    super.isEditMode = true,
    required super.post,
    required super.selectedTags,
    required super.tags,
    required super.isQuestion,
  });
}

@immutable
sealed class CuPostErrorState extends CuPostState {
  final String message;

  const CuPostErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class PostNotFoundState extends CuPostErrorState {
  const PostNotFoundState({required super.message});
}

final class UnAuthorizedState extends CuPostErrorState {
  const UnAuthorizedState({required super.message});
}

final class CuPostLoadErrorState extends CuPostErrorState {
  const CuPostLoadErrorState({required super.message});
}

final class CuOperationErrorState extends CuPostSubState {
  final String message;

  const CuOperationErrorState({
    required this.message,
    required super.isEditMode,
    required super.post,
    required super.selectedTags,
    required super.tags,
    required super.isQuestion,
  });

  @override
  List<Object?> get props => [
        message,
        super.isEditMode,
        super.post,
        super.selectedTags,
        super.tags,
        super.isQuestion
      ];
}

final class CuPostOperationSuccessState extends CuPostState {
  final Post post;

  const CuPostOperationSuccessState({required this.post});

  @override
  List<Object?> get props => [post];
}

final class SwitchModeState extends CuPostSubState {
  const SwitchModeState({
    required super.isEditMode,
    required super.post,
    required super.selectedTags,
    required super.tags,
    required super.isQuestion,
  });
}

final class AddedTagState extends CuPostSubState {
  const AddedTagState({
    required super.isEditMode,
    required super.post,
    required super.selectedTags,
    required super.tags,
    required super.isQuestion,
  });
}

final class RemovedTagState extends CuPostSubState {
  const RemovedTagState({
    required super.isEditMode,
    required super.post,
    required super.selectedTags,
    required super.tags,
    required super.isQuestion,
  });
}
