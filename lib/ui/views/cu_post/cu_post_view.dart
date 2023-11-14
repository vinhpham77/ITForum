import 'package:cay_khe/dtos/post_dto.dart';
import 'package:cay_khe/ui/views/cu_post/widgets/tag_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../repositories/tag_repository.dart';
import '../../../repositories/post_repository.dart';
import 'widgets/tag_item.dart';
import 'package:cay_khe/models/tag.dart';

class CuPost extends StatefulWidget {
  final String? action;
  final String? id;
  final bool? isQuestion;
  const CuPost({super.key, this.action, this.id, this.isQuestion});

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

  @override
  void initState() {
    super.initState();
    _loadTags();
    headingP1 = widget.action == 'update' ? 'Sửa' : 'Tạo';
    headingP2 = widget.isQuestion == true ? 'câu hỏi' : 'bài viết';
  }

  Future<void> _loadTags() async {
    List<Tag> tags = await tagRepository.get();
    setState(() {
      allTags = tags;
    });
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
                savePost(false);
                Navigator.pop(context);
              },
              child: const Text('Đăng lên', style: TextStyle(fontSize: 16)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 6),
              child: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    savePost(true);
                    Navigator.pop(context);
                  }
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
          child: TextField(
            controller: _titleController,
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
                      if (tag.name == 'hoidap') {
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
                          if (tag.name == 'hoidap') {
                            headingP2 = 'câu hỏi';
                          }
                          selectedTags.add(tag);
                          allTags.remove(tag);
                        });
                      },
                      label: selectedTags.isEmpty
                          ? 'Có thể gắn một đến ba thẻ...'
                          : "Gắn thêm một thẻ khác..."),
                )
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
          child: TextField(
            controller: _contentController,
            maxLines: null,
            decoration: const InputDecoration.collapsed(
              hintText: 'Viết nội dung ở đây...',
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        actionButtons
      ],
    );
    var postPreview = Column(
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
        actionButtons
      ],
    );
    return Scaffold(
      key: _formKey,
      backgroundColor: Colors.grey[100],
      body: Container(
        alignment: Alignment.center,
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
                            Navigator.pop(context);
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
      ),
    );
  }

  getMarkdown() {
    String titleRaw = _titleController.text;
    String title = titleRaw.isEmpty ? '' : '# **$titleRaw**';
    String tags = selectedTags.map((tag) => '#${tag.name}').join('\t');
    String content = _contentController.text;
    return '$title  \n###### $tags\n  # \n  $content';
  }

  savePost(bool isPrivate) {
    PostDTO postDTO = PostDTO(
      title: _titleController.text,
      content: _contentController.text,
      tags: selectedTags.map((tag) => tag.name).toList(),
      isPrivate: isPrivate,
      createdBy: DateTime.now().toIso8601String(),
    );

    postRepository.add(postDTO);
  }
}
