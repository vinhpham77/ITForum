import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/dtos/post_dto.dart';
import 'package:cay_khe/models/post.dart';
import 'package:cay_khe/models/tag.dart';
import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/cu_post/widgets/tag_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../widgets/add_image.dart';
import '/ui/widgets/notification.dart';
import 'bloc/cu_post_bloc.dart';
import 'bloc/cu_post_provider.dart';
import 'widgets/tag_item.dart';

const int _left = 3;
const int _right = 1;
const double contentHeight = 382 - bodyVerticalSpace;
final TextEditingController _contentController = TextEditingController();
final TextEditingController _titleController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class CuPost extends StatelessWidget {
  final String? id;
  final bool isQuestion;

  const CuPost({super.key, this.id, this.isQuestion = false});

  String get headingP1 => id == null ? 'Tạo' : 'Sửa';

  bool get isCreateMode => id == null;

  @override
  Widget build(BuildContext context) {
    return CuPostBlocProvider(
      id: id,
      isQuestion: isQuestion,
      child: BlocListener<CuPostBloc, CuPostState>(
        listener: (context, state) {
          if (state is CuPostOperationSuccessState) {
            appRouter.go('/posts/${state.post.id}');
          } else if (state is PostNotFoundState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
            appRouter.go('/not-found');
          } else if (state is UnAuthorizedState) {
            showTopRightSnackBar(context, state.message, NotifyType.warning);
            appRouter.go('/forbidden');
          } else if (state is CuPostLoadErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          } else if (state is CuOperationErrorState) {
            showTopRightSnackBar(context, state.message, NotifyType.error);
          }
        },
        child: Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          constraints:
              BoxConstraints(minWidth: MediaQuery.of(context).size.width),
          child: BlocBuilder<CuPostBloc, CuPostState>(
            builder: (context, state) {
              if (state is CuPostSubState) {
                _titleController.text = state.post?.title ?? '';
                _contentController.text = state.post?.content ?? '';
                return buildBodyContainer(child: _buildCuPost(context, state));
              } else if (state is CuPostLoadErrorState) {
                return buildBodyContainer(
                    child: Text(state.message,
                        style: const TextStyle(color: Colors.red)));
              }

              return buildBodyContainer(
                  child: const CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Container buildBodyContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: horizontalSpace, vertical: bodyVerticalSpace),
      constraints: const BoxConstraints(maxWidth: maxContent),
      child: child,
    );
  }

  Widget _buildCuPost(BuildContext context, CuPostSubState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTopBarRow(context, state),
          Row(
            children: [
              Expanded(
                flex: _left,
                child: state.isEditMode
                    ? _buildPostEditingTab(context, state)
                    : _buildPostPreviewTab(context, state),
              ),
              Expanded(
                flex: _right,
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 40,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildTopBarRow(BuildContext context, CuPostSubState state) {
    return Row(
      children: [
        Expanded(
          flex: _left,
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text(
                    '$headingP1 ${getHeadingP2(state)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    buildSwitchModeButton(
                        context, 'Chỉnh sửa', true, state.isEditMode, state),
                    buildSwitchModeButton(
                        context, 'Xem trước', false, state.isEditMode, state)
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: _right,
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            height: 40,
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                appRouter.go('/');
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _buildPostPreviewTab(BuildContext context, CuPostSubState state) {
    return Column(
      children: [
        Container(
          height: contentHeight + 196,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          child: Markdown(
            data: getMarkdown(state),
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              textScaleFactor: 1.4,
              h1: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 32),
              h2: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 28),
              h3: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20),
              h6: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 13),
              p: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
              blockquote: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
              listBullet: const TextStyle(fontSize: 16),
            ),
            softLineBreak: true,
          ),
        ),
        _buildActionContainer(context, state)
      ],
    );
  }

  Column _buildPostEditingTab(BuildContext context, CuPostSubState state) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          child: TextFormField(
            controller: _titleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tiêu đề';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Viết tiêu đề ở đây...',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            left: 48,
            right: 48,
            top: 8,
            bottom: 12,
          ),
          child: Row(
            children: [
              for (var tag in state.selectedTags)
                CustomTagItem(
                  tagName: tag.name,
                  onDelete: () => removeSelectedTag(context, tag, state),
                ),
              if (state.selectedTags.length < 3)
                TagDropdown(
                    tags: state.tags,
                    onTagSelected: (tag) => _selectTag(context, tag, state),
                    label: state.selectedTags.isEmpty
                        ? 'Gắn một đến ba thẻ...'
                        : "Gắn thêm thẻ khác..."),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              height: contentHeight + (state.selectedTags.length == 3 ? 8 : 0),
              child: TextFormField(
                controller: _contentController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
                maxLines: null,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Viết nội dung ở đây...',
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: AddImage(imageCallback: insertText),
            ),
          ],
        ),
        _buildActionContainer(context, state)
      ],
    );
  }

  TextButton buildSwitchModeButton(BuildContext context, String text,
      bool origin, bool active, CuPostSubState state) {
    return TextButton(
      onPressed: () {
        if (origin == active) {
          return;
        }

        Post newPost;
        var tags = state.selectedTags.map((tag) => tag.name).toList();
        if (state.post == null) {
          newPost = Post(
              title: _titleController.text,
              content: _contentController.text,
              tags: tags,
              isPrivate: false,
              createdBy: '',
              updatedAt: DateTime.now(),
              score: 0,
              commentCount: 0,
              id: '');
        } else {
          newPost = state.post!.copyWith(
              title: _titleController.text,
              content: _contentController.text,
              tags: tags);
        }

        context.read<CuPostBloc>().add(SwitchModeEvent(
            isEditMode: origin,
            post: newPost,
            selectedTags: state.selectedTags,
            tags: state.tags,
            isQuestion: state.isQuestion));
      },
      child: Text(text, style: _getTextStyle(origin == active)),
    );
  }

  TextStyle _getTextStyle(bool active) {
    if (active) {
      return const TextStyle(
          color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500);
    }

    return const TextStyle(
        color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400);
  }

  Container _buildActionContainer(BuildContext context, CuPostSubState state) {
    bool isWaiting =
        state is CuPublicPostWaitingState || state is CuPrivatePostWaitingState;

    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: isWaiting
                  ? null
                  : () {
                      savePost(context, false, state);
                    },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text('Đăng lên', style: TextStyle(fontSize: 16)),
                  if (state is CuPublicPostWaitingState)
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: isWaiting
                        ? null
                        : () {
                            savePost(context, true, state);
                          },
                    child:
                        const Text('Lưu tạm', style: TextStyle(fontSize: 16)),
                  ),
                  if (state is CuPrivatePostWaitingState)
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          ],
        ));
  }

  void removeSelectedTag(BuildContext context, Tag tag, CuPostSubState state) {
    Post post = getNewPost(state);

    context.read<CuPostBloc>().add(RemoveTagEvent(
        tag: tag,
        isEditMode: state.isEditMode,
        post: post,
        selectedTags: state.selectedTags,
        isQuestion: state.isQuestion,
        tags: state.tags));
  }

  _selectTag(BuildContext context, Tag tag, CuPostSubState state) {
    Post post = getNewPost(state);

    context.read<CuPostBloc>().add(AddTagEvent(
        tag: tag,
        isEditMode: state.isEditMode,
        post: post,
        selectedTags: state.selectedTags,
        tags: state.tags,
        isQuestion: state.isQuestion));
  }

  Post getNewPost(CuPostSubState state) {
    Post post;
    if (state.post == null) {
      post = Post(
          title: _titleController.text,
          content: _contentController.text,
          tags: [],
          isPrivate: false,
          createdBy: '',
          updatedAt: DateTime.now(),
          score: 0,
          commentCount: 0,
          id: '');
    } else {
      post = state.post!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
      );
    }
    return post;
  }

  getMarkdown(CuPostSubState state) {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String tags = state.selectedTags.map((tag) => '#${tag.name}').join('\t');
    String content = _contentController.text;
    return '$title  \n###### $tags\n  # \n  $content';
  }

  savePost(BuildContext context, bool isPrivate, CuPostSubState state) async {
    if (!validateOnPressed(context, state)) {
      return;
    }

    context.read<CuPostBloc>().add(CuPostOperationEvent(
        postDTO: createDTO(isPrivate, state),
        isEditMode: state.isEditMode,
        isCreate: isCreateMode,
        post: state.post,
        isQuestion: state.isQuestion,
        selectedTags: state.selectedTags,
        tags: state.tags));
  }

  PostDTO createDTO(bool isPrivate, CuPostSubState state) {
    return PostDTO(
      title: _titleController.text,
      content: _contentController.text,
      tags: state.selectedTags.map((tag) => tag.name).toList(),
      isPrivate: isPrivate,
    );
  }

  String? validateSelectedTags(List<Tag> selectedTags) {
    if (selectedTags.isEmpty) {
      return 'Vui lòng chọn ít nhất một tag';
    }
    if (selectedTags.length > 3) {
      return 'Chỉ được chọn tối đa 3 tag';
    }
    return null;
  }

  bool validateOnPressed(BuildContext context, CuPostSubState state) {
    if (_formKey.currentState!.validate()) {
      String? tagValidation = validateSelectedTags(state.selectedTags);

      if (tagValidation != null) {
        showTopRightSnackBar(context, tagValidation, NotifyType.warning);
      } else {
        return true;
      }
    }

    return false;
  }

  String getHeadingP2(CuPostSubState state) {
    if (state.isQuestion) {
      return 'câu hỏi';
    }
    return 'bài viết';
  }

  void insertText(String input) {
    final text = _contentController.text;
    final textSelection = _contentController.selection;
    final String newText;
    final int cursorPosition = textSelection.isValid ? textSelection.end : text.length;

    newText = text.replaceRange(cursorPosition, cursorPosition, input);

    final textSelectionNew = TextSelection.collapsed(offset: cursorPosition + input.length);

    _contentController.text = newText;
    _contentController.selection = textSelectionNew;
  }
}
