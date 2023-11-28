import 'package:cay_khe/dtos/jwt_payload.dart';
import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/dtos/post_dto.dart';
import 'package:cay_khe/models/post.dart';
import 'package:cay_khe/models/tag.dart';
import 'package:cay_khe/ui/common/utils/index.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/cu_post/widgets/tag_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/post_repository.dart';
import '../../../repositories/tag_repository.dart';
import '/ui/widgets/notification.dart';
import 'widgets/tag_item.dart';

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
  final tagRepository = TagRepository();
  final postRepository = PostRepository();
  final _formKey = GlobalKey<FormState>();
  late String headingP1;
  late String headingP2;
  Tag? selectedTag;
  bool _isEditing = true;
  final int _left = 3;
  final int _right = 1;
  List<Tag> selectedTags = [];
  List<Tag> allTags = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    headingP1 = widget.id == null ? 'Tạo' : 'Sửa';

    Future.wait([_loadTags(), _loadPost()]).then((value) {
      headingP2 = widget.isQuestion ? 'câu hỏi' : 'bài viết';
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (headingP1 == 'Sửa' && widget.id != null && isLoaded) {
      return _buildCuPost(context);
    }

    return const Center(child: CircularProgressIndicator());
  }

  Center _buildCuPost(BuildContext context) {
    return Center(
      child: Container(
        width: 1200,
        margin: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
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
                              '$headingP1 $headingP2',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = !_isEditing;
                                  });
                                },
                                child: Text(
                                  'Chỉnh sửa',
                                  style: TextStyle(
                                    color: (_isEditing)
                                        ? Colors.black87
                                        : Colors.grey.shade400,
                                    fontSize: 16,
                                    fontWeight: (_isEditing)
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = !_isEditing;
                                  });
                                },
                                child: Text(
                                  'Xem trước',
                                  style: TextStyle(
                                    color: (!_isEditing)
                                        ? Colors.black87
                                        : Colors.grey.shade400,
                                    fontSize: 16,
                                    fontWeight: (!_isEditing)
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
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
                          appRouter.pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: _left,
                    child: (_isEditing)
                        ? _buildPostEditingTab()
                        : _buildPostPreviewTab(context),
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
        ),
      ),
    );
  }

  Column _buildPostPreviewTab(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 620,
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
          padding: const EdgeInsets.only(
            left: 64,
            right: 64,
            top: 32,
            bottom: 32,
          ),
          child: Markdown(
            data: getMarkdown(),
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
              // Custom blockquote style
              listBullet: const TextStyle(
                  fontSize: 16), // Custom list item bullet style
            ),
            softLineBreak: true,
          ),
        ),
        _buildActionContainer()
      ],
    );
  }

  Column _buildPostEditingTab() {
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
          padding: const EdgeInsets.only(
            left: 64,
            right: 64,
            top: 32,
            bottom: 32,
          ),
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
                fontSize: 48,
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
            onChanged: (value) {
              setState(() {});
            },
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
            left: 64,
            right: 64,
            top: 8,
            bottom: 12,
          ),
          child: Row(
            children: [
              for (var tag in selectedTags)
                CustomTagItem(
                  tagName: tag.name,
                  onDelete: () {
                    setState(() {
                      if (tag.name == 'HoiDap') {
                        headingP2 = 'bài viết';
                      }
                      selectedTags.remove(tag);
                      allTags.add(tag);
                    });
                  },
                ),
              if (selectedTags.length < 3)
                SizedBox(
                  child: TagDropdown(
                      tags: allTags,
                      onTagSelected: (tag) {
                        setState(() {
                          if (tag.name == 'HoiDap') {
                            headingP2 = 'câu hỏi';
                          }
                          selectedTags.add(tag);
                          allTags.remove(tag);
                        });
                      },
                      label: selectedTags.isEmpty
                          ? 'Gắn một đến ba thẻ...'
                          : "Gắn thêm thẻ khác..."),
                ),
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
          padding: const EdgeInsets.only(
            left: 64,
            right: 64,
            top: 32,
            bottom: 32,
          ),
          height: 400,
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
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        _buildActionContainer()
      ],
    );
  }

  Container _buildActionContainer() {
    return Container(
        margin: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () {
                savePost(false);
              },
              child: const Text('Đăng lên', style: TextStyle(fontSize: 16)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  savePost(true);
                },
                child: const Text('Lưu tạm', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ));
  }

  getMarkdown() {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String tags = selectedTags.map((tag) => '#${tag.name}').join('\t');
    String content = _contentController.text;
    return '$title  \n###### $tags\n  # \n  $content';
  }

  savePost(bool isPrivate) async {
    if (!validateOnPressed()) {
      return;
    }

    PostDTO postDTO = createDTO(isPrivate);

    Future<Response<dynamic>> future;
    if (widget.id == null) {
      future = postRepository.add(postDTO);
    } else {
      future = postRepository.update(widget.id!, postDTO);
    }

    future.then((response) {
      Post post = Post.fromJson(response.data);
      showTopRightSnackBar(
          context, '$headingP1 $headingP2 thành công!', NotifyType.success);
      GoRouter.of(context).go('/posts/${post.id}');
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  PostDTO createDTO(bool isPrivate) {
    return PostDTO(
      title: _titleController.text,
      content: _contentController.text,
      tags: selectedTags.map((tag) => tag.name).toList(),
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

  bool validateOnPressed() {
    if (_formKey.currentState!.validate()) {
      String? tagValidation = validateSelectedTags(selectedTags);

      if (tagValidation != null) {
        showTopRightSnackBar(context, tagValidation, NotifyType.warning);
      } else {
        return true;
      }
    }

    return false;
  }

  Future<void> _loadTags() async {
    var future = tagRepository.get();

    future.then((response) {
      List<Tag> tags = response.data.map<Tag>((tag) {
        return Tag.fromJson(tag);
      }).toList();
      setState(() {
        allTags = tags;

        if (widget.isQuestion) {
          selectedTags.add(allTags.firstWhere((tag) => tag.name == 'HoiDap'));
          allTags.removeWhere((tag) => tag.name == 'HoiDap');
        }
      });
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Future<void> _loadPost() async {
    if (widget.id == null) {
      return;
    }

    var future = postRepository.getOne(widget.id!);

    future.then((response) {
      Post post = Post.fromJson(response.data);
      if (JwtPayload.sub != post.createdBy) {
        Navigator.pop(context);
        appRouter.go('/forbidden');
        return;
      }

      setState(() {
        _titleController.text = post.title;
        _contentController.text = post.content;
        selectedTags = post.tags.map((tagName) {
          if (tagName == 'HoiDap') {
            headingP2 = 'câu hỏi';
          }
          var tag = allTags.firstWhere((tag) => tag.name == tagName);
          allTags.remove(tag);
          return tag;
        }).toList();
      });
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 404) {
          appRouter.go('/not-found');
        } else if (error.response?.statusCode == 403) {
          appRouter.go('/forbidden');
        } else {
          String message = getMessageFromException(error);
          showTopRightSnackBar(context, message, NotifyType.error);
        }
      }
    });
  }
}
