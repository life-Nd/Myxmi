import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropperScreen extends StatefulWidget {
  final String title;
  final Route route;

  const ImageCropperScreen({@required this.title, @required this.route});

  @override
  _ImageCropperScreenState createState() => _ImageCropperScreenState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  AppState state;
  File imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: state == AppState.cropped
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _clearImage(),
                )
              ]
            : null,
      ),
      body: Center(
        child: imageFile != null ? Image.file(imageFile) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == AppState.free) {
            _pickImage();
          } else if (state == AppState.picked) {
            _cropImage();
          } else if (state == AppState.cropped) useImageOnPreviousScreen();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free) {
      return const Icon(Icons.add);
    } else if (state == AppState.picked) {
      return const Icon(Icons.crop);
    } else if (state == AppState.cropped) {
      return const Icon(Icons.save);
    } else {
      return Container();
    }
  }

  Future _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future _cropImage() async {
    final File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  void useImageOnPreviousScreen() {
    // Sends to previous screen
    Navigator.of(context).pushAndRemoveUntil(widget.route, (route) => false);
  }
}
