import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/dtos/series_dto.dart';
import 'package:cay_khe/models/post.dart';
import 'package:cay_khe/repositories/series_repository.dart';
import 'package:cay_khe/ui/common/app_constants.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:cay_khe/ui/views/cu_series/widgets/post_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../../dtos/jwt_payload.dart';
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
  bool isLoaded = false;
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
    operation = widget.id == null ? 'Tạo' : 'Sửa';

    Future.wait([_loadSeries(), _loadPosts()]).then((value) {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (operation == 'Sửa' && widget.id != null && isLoaded == false) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildCuSeries(context);
  }

  Center _buildCuSeries(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: maxContent),
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                    child: (_isEditing)
                        ? _buildSeriesEditingTab(context)
                        : _buildSeriesPreviewTab(context),
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

  Column _buildSeriesPreviewTab(BuildContext context) {
    return Column(
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
              listBullet: const TextStyle(fontSize: 16),
            ),
            softLineBreak: true,
          ),
        ),
        _buildActionContainer()
      ],
    );
  }

  Column _buildSeriesEditingTab(BuildContext context) {
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
              right: 0,
              top: 8,
              bottom: 12,
            ),
            child: Column(
              children: [
                Column(children: [
                  for (var post in selectedPosts)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: PostItem(post: post)),
                        TextButton(
                          onPressed: () => removeSelectedPost(post),
                          child: const Icon(Icons.close,
                              size: 20, color: Colors.black54, opticalSize: 20),
                        ),
                        Container(
                          width: 64,
                        )
                      ],
                    ),
                ]),
                if (selectedPosts.isEmpty)
                  Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.only(top: 4, bottom: 4, right: 64),
                    child: const Text(
                        'Chưa có bài viết nào. Vui lòng thêm tối thiểu 1 bài viết để chia sẻ với mọi người!'),
                  ),
                if (selectedPosts.isNotEmpty)
                  Divider(
                    endIndent: 64,
                    thickness: 1,
                    color: Colors.black12.withOpacity(0.05),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 64 + 4, 4),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side:
                          BorderSide(color: Colors.deepPurple.withOpacity(0.5)),
                    ),
                    onPressed: () => buildShowModalBottomSheet(context),
                    child: const Text('Thêm bài viết'),
                  ),
                )
              ],
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
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 500,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: const Text(
                    'Thêm bài viết',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: openModal(),
                ),
              ],
            ),
          );
        });
  }

  ListView _buildPostListView() {
    return ListView.builder(
      itemCount: allPosts.length,
      itemBuilder: (context, index) {
        return PostItem(
            post: allPosts[index],
            onTap: () {
              setState(() {
                selectedPosts.add(allPosts[index]);
                allPosts.removeAt(index);
              });
              Navigator.pop(context);
            });
      },
    );
  }

  getMarkdown() {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String posts = '';
    String content = _contentController.text;
    return '$title  \n###### $posts\n  # \n  $content';
  }

  saveSeries(bool isPrivate) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (operation == 'Sửa' && selectedPosts.isEmpty) {
      showTopRightSnackBar(
          context, 'Vui lòng thêm ít nhất 1 bài viết', NotifyType.warning);
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
        postIds: selectedPosts.map((post) => post.id).toList());
  }

  Future<void> _loadPosts() async {
    var future = postRepository.getByUser(JwtPayload.sub!);

    future.then((response) {
      List<Post> posts = response.data.map<Post>((post) {
        return Post.fromJson(post);
      }).toList();

      List<Post> postsToAddToSelected = [];

      for (int i = 0; i < posts.length; i++) {
        if (selectedPostIds.contains(posts[i].id)) {
          postsToAddToSelected.add(posts[i]);
          posts.removeAt(i--);
        }
      }

      setState(() {
        allPosts = posts;
        selectedPosts.addAll(postsToAddToSelected);
      });
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
    });
  }

  Future<void> _loadSeries() async {
    var future = seriesRepository.getOne(widget.id!);

    future.then((response) {
      Series series = Series.fromJson(response.data);

      if (series.createdBy != JwtPayload.sub) {
        Navigator.pop(context);
        appRouter.go('/forbidden');
        return;
      }

      setState(() {
        _titleController.text = series.title;
        _contentController.text = series.content;
        selectedPostIds = series.postIds;
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

  void removeSelectedPost(post) {
    setState(() {
      selectedPosts.remove(post);
      allPosts.add(post);
    });
  }

  openModal() {
    if (allPosts.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Không còn bài viết nào. Thêm bài viết mới'),
            TextButton(
              onPressed: () {
                appRouter.go('/publish/post');
              },
              child: const Text('tại đây'),
            ),
          ],
        ),
      );
    }

    return _buildPostListView();
  }
}
