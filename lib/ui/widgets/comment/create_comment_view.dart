import 'package:cay_khe/dtos/comment.dart';
import 'package:cay_khe/ui/widgets/add_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api_config.dart';
import '../../../dtos/jwt_payload.dart';
import '../../../dtos/notify_type.dart';
import '../../../dtos/sub_comment_aggregate.dart';
import '../../../dtos/sub_comment_dto.dart';
import '../../../repositories/comment_repository.dart';
import '../../../repositories/image_repository.dart';
import '../../common/utils/message_from_exception.dart';
import '../notification.dart';
import '../user_avatar.dart';

typedef CommentChangedCallback = Function(SubCommentAggreGate subCommentAggreGate);

class CreateCommentView extends StatefulWidget {
  final String postId;
  final String subId;
  final CommentChangedCallback callback;
  final String context;
  CreateCommentView({required this.postId, this.subId = '', required this.callback, this.context = ''});
  @override
  State<CreateCommentView> createState() => _CreateCommentViewState();
}

class _CreateCommentViewState extends State<CreateCommentView> {
  bool _isEditing = true;
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CommentRepository commentRepository = CommentRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contentController.text = widget.context;
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child:Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child: Text(
                    'Viết',
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:UserAvatar(imageUrl: JwtPayload.avatarUrl, size: 32,),
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            _isEditing ? _buildCommentEditingTab() : _buildCommentPreviewTab(context),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            height: 36,
                            width: 100,
                            child: FloatingActionButton(
                              backgroundColor: Color.fromRGBO(96, 120, 254, 1),
                              onPressed: () {
                                if(!validateOnPressed())
                                  return;
                                Future<Response<dynamic>> future;
                                if(widget.context == '')
                                  future = commentRepository.add(widget.postId, createCommentDto(widget.subId));
                                else
                                  future = commentRepository.updateSubComment(widget.postId, widget.subId, createCommentDto(""));
                                future.then((response) {
                                  widget.callback(SubCommentAggreGate.fromJson(response.data));

                                  _contentController.text = "";
                                }).catchError((error) {
                                  String message = getMessageFromException(error);
                                  showTopRightSnackBar(context, message, NotifyType.error);
                                });
                              },
                              child: Text(widget.context == '' ? "Bình luận" : "Cập nhật", style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        )
    );
  }

  Widget _buildCommentEditingTab() {
    return Expanded(
      child: Container(
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
            left: 32,
            right: 32,
            top: 16,
            bottom: 16,
          ),
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: TextFormField(
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
              ),),
              Column(
                children: [
                  AddImage(imageCallback: insertText)
                ],
              )
            ],
          )
      ),
    );
  }

  Widget _buildCommentPreviewTab(BuildContext context) {
    return Expanded(
      child: Container(
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
          left: 32,
          right: 32,
          top: 16,
          bottom: 16,
        ),
        height: 200,
        child: Markdown(
          data: _contentController.text,
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
    );
  }

  void insertText(String input) {
    final text = _contentController.text;
    final textSelection = _contentController.selection;
    final newText;
    if(!textSelection.isValid)
      newText = input;
    else
      newText = text.replaceRange(textSelection.start, textSelection.end, input);
    final textSelectionNew = TextSelection.collapsed(offset: textSelection.start + input.length);

    _contentController.text = newText;
    _contentController.selection = textSelectionNew;
  }

  // addComment() async {
  //   if(!validateOnPressed())
  //     return;
  //
  //   Future<Response<dynamic>> future = commentRepository.add(widget.postId, createCommentDto(widget.idFather));
  //   future.then((response) {
  //     widget.callback(SubCommentAggreGate.fromJson(response.data));
  //
  //     _contentController.text = "";
  //   }).catchError((error) {
  //     String message = getMessageFromException(error);
  //     showTopRightSnackBar(context, message, NotifyType.error);
  //   });
  // }

  SubCommentDto createCommentDto(String idFather) {
    return SubCommentDto(subCommentFatherId: idFather,username: JwtPayload.sub ?? "", content: _contentController.text);
  }

  bool validateOnPressed() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }
}