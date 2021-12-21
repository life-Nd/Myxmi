import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final imageProvider =
    ChangeNotifierProvider<ImageProvider>((ref) => ImageProvider());

enum AppState {
  empty,
  picked,
  cropped,
  webOS,
}

class ImageProvider extends ChangeNotifier {
  AppState state = AppState.empty;
  File? imageFile;
  Uint8List? dataUint8;
  Widget? imageWidget;
  // String? urlString;
  String imageUrl = '';
  String imageId = '';
  String? added;
  final picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 77);
    if (pickedFile != null) {
      pickedFile.readAsBytes();
      kIsWeb ? await getImageWeb(pickedFile) : getImageFile(pickedFile);
      notifyListeners();
    } else {
      debugPrint('source is empty');
    }
  }

  void getImageFile(XFile file) {
    debugPrint('file: ${file.path}');
    imageFile = File(file.path);
    imageWidget = Image.memory(imageFile!.readAsBytesSync());
    state = AppState.picked;
    notifyListeners();
  }

  Future getImageWeb(XFile file) async {
    debugPrint('file: ${file.path}');
    dataUint8 = await file.readAsBytes();
    imageWidget = Image.memory(dataUint8!);
    state = AppState.picked;
    debugPrint('stateIMAGEWEB: $state');
    notifyListeners();
  }

  Future cropImage() async {
    if (!kIsWeb) {
      final File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
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
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ),
      );

      if (croppedFile != null) {
        imageFile = croppedFile;
        state = AppState.cropped;
        notifyListeners();
      } else {
        state = AppState.empty;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future<String?> addImageToDb({required BuildContext context}) async {
    firebase_storage.UploadTask task;
    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final rng = Random();
    final _random = rng.nextInt(90000) + 10000;
    imageId = '$timeStamp-$_random}';
    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("$timeStamp-$_random.jpg");
    if (kIsWeb) {
      task = firebaseStorageRef.putData(dataUint8!);
    } else {
      task = firebaseStorageRef.putFile(imageFile!);
    }
    await task.then(
      (value) async {
        imageUrl = await value.ref.getDownloadURL();
        state = AppState.empty;
        notifyListeners();
      },
    );
    debugPrint("Url for Download: $imageUrl");

    return imageUrl;
  }

  void reset() {
    imageId = '';
    imageUrl = '';
    state = AppState.empty;
    imageFile?.delete();
  }
}
