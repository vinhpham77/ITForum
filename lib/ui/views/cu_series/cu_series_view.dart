import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/dtos/series_dto.dart';
import 'package:cay_khe/models/post.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../../models/series.dart';
import '../../../repositories/post_repository.dart';
import '/ui/widgets/notification.dart';

class CuSeries extends StatefulWidget {
  final String? id;

  const CuSeries({super.key, this.id});

  @override
  State<CuSeries> createState() => _CuSeriesState();
}

class _CuSeriesState extends State<CuSeries> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final seriesRepository = SeriesRepository();
  final postRepository = PostRepository();
  final _formKey = GlobalKey<FormState>();
  late String operation;
  Post? selectedPost;
  bool _isEditing = true;
  final int _left = 3;
  final int _right = 1;
  List<Post> selectedPosts = [];
  List<String> selectedPostIds = [];
  List<Post> allPosts = [];
  final double _contentHeight = 460;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _loadSeries();
      _loadPosts();
    }
    operation = widget.id == null ? 'Tạo' : 'Sửa';
  }

  @override
  Widget build(BuildContext context) {
    var actionButtons = Container(
        margin: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () {
                saveSeries(false);
              },
              child: const Text('Đăng lên', style: TextStyle(fontSize: 16)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  saveSeries(true);
                },
                child: const Text('Lưu tạm', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ));
    var postEditing = Column(
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
          height: _contentHeight,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: widget.id == null
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))
                : null,
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            left: 64,
            right: 64,
            top: 32,
            bottom: 32,
          ),
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
        if (widget.id != null)
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
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            padding: const EdgeInsets.only(
              left: 64,
              right: 64,
              top: 8,
              bottom: 12,
            ),
            child: Row(
              children: [
                for (var post in selectedPosts)
                  // CustomTagItem(
                  //   tagName: post.name,
                  //   onDelete: () {
                  //     setState(() {
                  //       if (post.name == 'hoidap') {
                  //         headingP2 = 'bài viết';
                  //       }
                  //       selectedPosts.remove(post);
                  //       allPosts.add(post);
                  //     });
                  //   },
                  // ),
                  // if (selectedPosts.length < 3)
                  //   SizedBox(
                  //     child: TagDropdown(
                  //         tags: allPosts,
                  //         onTagSelected: (post) {
                  //           setState(() {
                  //             selectedPosts.add(post);
                  //             allPosts.remove(post);
                  //           });
                  //         },
                  //         label: selectedPosts.isEmpty
                  //             ? 'Có thể gắn một đến ba thẻ...'
                  //             : "Gắn thêm một thẻ khác..."),
                  //   ),
                  const Text('data'),
              ],
            ),
          ),
        actionButtons
      ],
    );
    var postPreview = Column(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 152 + _contentHeight),
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
        actionButtons
      ],
    );
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
                              '$operation series',
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
                          GoRouter.of(context).go('/');
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
                    child: (_isEditing) ? postEditing : postPreview,
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

  getMarkdown() {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String posts = ''; //selectedPosts.map((tag) => '#${tag.name}').join('\t');
    String content = _contentController.text;
    return '$title  \n###### $posts\n  # \n  $content';
  }

  saveSeries(bool isPrivate) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SeriesDTO seriesDTO = createDTO(isPrivate);

    Future<Response<dynamic>> future;
    if (widget.id == null) {
      future = seriesRepository.add(seriesDTO);
    } else {
      future = seriesRepository.update(widget.id!, seriesDTO);
    }

    future.then((response) {
      Series series = Series.fromJson(response.data);

      if (operation == 'Tạo') {
        appRouter.go('/series/${series.id}/edit');
      } else {
        appRouter.go('/series/${series.id}');
      }
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  SeriesDTO createDTO(bool isPrivate) {
    return SeriesDTO(
        title: _titleController.text,
        content: _contentController.text,
        isPrivate: isPrivate,
        postIds: []);
  }

  Future<void> _loadPosts() async {
    var future = postRepository.getByUser();

    future.then((response) {
      List<Post> posts = response.data.map<Post>((post) {
        return Post.fromJson(post);
      }).toList();
      setState(() {
        allPosts = posts;

        for (Post post in posts) {
          if (selectedPostIds.contains(post.id)) {
            selectedPosts.add(post);
            allPosts.remove(post);
          }
        }
      });
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  void _loadSeries() {
    var future = seriesRepository.getOne(widget.id!);

    future.then((response) {
      Series series = Series.fromJson(response.data);

      setState(() {
        _titleController.text = series.title;
        _contentController.text = series.content;
        selectedPostIds = series.postIds;
      });
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }
}
