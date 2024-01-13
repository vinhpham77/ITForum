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
  const AddImage({super.key, required this.imageCallback});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final ImageRepository _imageRepository = ImageRepository();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: getImage,
      tooltip: 'Thêm ảnh',
      icon: const Icon(Icons.image),
    );
  }

  Future getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      var future = _imageRepository.upload(image);
      future.then((response) {
        widget.imageCallback('![Mô tả ảnh](${ApiConfig.baseUrl}/${ApiConfig.imagesEndpoint}/${response.data.toString()})');
      }).catchError((error) {
        String message = getMessageFromException(error);
        showTopRightSnackBar(context, message, NotifyType.error);
      });
    }
  }
}