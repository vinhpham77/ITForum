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

import '../../../repositories/post_repository.dart';
import '../../../repositories/tag_repository.dart';
import '/ui/widgets/notification.dart';
import 'bloc/cu_post_bloc.dart';
import 'widgets/tag_item.dart';

const int _left = 3;
const int _right = 1;
const double contentHeight = 382 - bodyVerticalSpace;

class CuPost extends StatefulWidget {
  final String? id;
  final bool isQuestion;

  const CuPost({super.key, this.id, this.isQuestion = false});

  @override
  State<CuPost> createState() => _CuPostState();
}

class _CuPostState extends State<CuPost> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String get headingP1 => widget.id == null ? 'Tạo' : 'Sửa';

  bool get isCreateMode => widget.id == null;
  final CuPostBloc _bloc = CuPostBloc(
    postRepository: PostRepository(),
    tagRepository: TagRepository(),
  );

  @override
  void initState() {
    super.initState();

    if (isCreateMode) {
      _bloc.add(InitEmptyPostEvent(isQuestion: widget.isQuestion));
    } else {
      _bloc.add(LoadPostEvent(id: widget.id!, isQuestion: widget.isQuestion));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
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
            appRouter.go('/');
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
              if (state is SwitchModeState) {
                _titleController.text = state.post?.title ?? '';
                _contentController.text = state.post?.content ?? '';
                return buildBodyContainer(child: _buildCuPost(context, state));
              }
              if (state is CuPostSubState) {
                _titleController.text = state.post?.title ?? '';
                _contentController.text = state.post?.content ?? '';
                return buildBodyContainer(child: _buildCuPost(context, state));
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
          _buildTopBarRow(state),
          Row(
            children: [
              Expanded(
                flex: _left,
                child: state.isEditMode
                    ? _buildPostEditingTab(state)
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

  Row _buildTopBarRow(CuPostSubState state) {
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
                        'Chỉnh sửa', true, state.isEditMode, state),
                    buildSwitchModeButton(
                        'Xem trước', false, state.isEditMode, state)
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
    var space = (state.selectedTags.length == 3 ? 8 : 0);
    return Column(
      children: [
        Container(
          height: contentHeight + 196 - space,
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
        _buildActionContainer(state)
      ],
    );
  }

  Column _buildPostEditingTab(CuPostSubState state) {
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
                  onDelete: () => removeSelectedTag(tag, state),
                ),
              if (state.selectedTags.length < 3)
                TagDropdown(
                    tags: state.tags,
                    onTagSelected: (tag) => _selectTag(tag, state),
                    label: state.selectedTags.isEmpty
                        ? 'Gắn một đến ba thẻ...'
                        : "Gắn thêm thẻ khác..."),
            ],
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
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          height: contentHeight,
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
        _buildActionContainer(state)
      ],
    );
  }

  TextButton buildSwitchModeButton(
      String text, bool origin, bool active, CuPostSubState state) {
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

        _bloc.add(SwitchModeEvent(
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

  Container _buildActionContainer(CuPostSubState state) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () {
                savePost(false, state);
              },
              child: const Text('Đăng lên', style: TextStyle(fontSize: 16)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  savePost(true, state);
                },
                child: const Text('Lưu tạm', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ));
  }

  void removeSelectedTag(Tag tag, CuPostSubState state) {
    Post post = getNewPost(state);

    _bloc.add(RemoveTagEvent(
        tag: tag,
        isEditMode: state.isEditMode,
        post: post,
        selectedTags: state.selectedTags,
        isQuestion: state.isQuestion,
        tags: state.tags));
  }

  _selectTag(Tag tag, CuPostSubState state) {
    Post post = getNewPost(state);

    _bloc.add(AddTagEvent(
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

  savePost(bool isPrivate, CuPostSubState state) async {
    if (!validateOnPressed(state)) {
      return;
    }

    if (isCreateMode) {
      _bloc.add(CreatePostEvent(
          postDTO: createDTO(isPrivate, state),
          isEditMode: state.isEditMode,
          post: state.post,
          isQuestion: state.isQuestion,
          selectedTags: state.selectedTags,
          tags: state.tags));
    } else {
      _bloc.add(UpdatePostEvent(
          postDTO: createDTO(isPrivate, state),
          isEditMode: state.isEditMode,
          post: state.post,
          isQuestion: state.isQuestion,
          selectedTags: state.selectedTags,
          tags: state.tags));
    }
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

  bool validateOnPressed(CuPostSubState state) {
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
}
