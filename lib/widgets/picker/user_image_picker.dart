import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  const UserImagePicker(this.imagePickFn, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: getAvatarImage(),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
              surfaceTintColor: Theme.of(context).primaryColor),
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }

  ImageProvider<Object>? getAvatarImage() {
    if (_pickedImage == null) return null;
    return FileImage(_pickedImage!);
  }

  void _pickImage() async {
    final pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) return;

    final file = File(pickedImage.path);

    setState(() {
      _pickedImage = file;
    });
    widget.imagePickFn(file);
  }
}
