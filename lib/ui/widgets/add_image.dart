import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../api_config.dart';
import '../../dtos/notify_type.dart';
import '../../repositories/image_repository.dart';
import '../common/utils/message_from_exception.dart';
import 'notification.dart';

typedef ImageCallback = Function(String imagePath);

class AddImage extends StatefulWidget {
  final ImageCallback imageCallback;
  AddImage({required this.imageCallback});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final ImageRepository _imageRepository = ImageRepository();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: getImage,
      tooltip: 'Add image',
      icon: Icon(Icons.image),
    );
  }

  Future getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      var future = _imageRepository.upload(image);
      future.then((response) {
        widget.imageCallback('![Tux, the Linux mascot](${ApiConfig.baseUrl}/${ApiConfig.imagesEndpoint}/${response.data.toString()})');
      }).catchError((error) {
        String message = getMessageFromException(error);
        showTopRightSnackBar(context, message, NotifyType.error);
      });
    } else {
      print('No image selected.');
    }
  }
}