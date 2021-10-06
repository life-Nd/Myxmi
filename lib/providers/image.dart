import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

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
  File imageFile;
  Uint8List dataUint8;
  Widget imageWidget;
  String urlString;
  String imageLink = '';
  String imageId = '';
  String added;
  final picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 77);
    if (pickedFile != null) {
      pickedFile.readAsBytes();
      kIsWeb ? await changeImageWeb(pickedFile) : changeImageFile(pickedFile);
      notifyListeners();
    } else {
      debugPrint('source is empty');
    }
  }

  void changeImageFile(XFile file) {
    debugPrint('file: ${file.path}');
    imageFile = File(file.path);
    imageWidget = Image.memory(imageFile.readAsBytesSync());
    state = AppState.picked;
    notifyListeners();
  }

  Future changeImageWeb(XFile file) async {
    debugPrint('file: ${file.path}');
    dataUint8 = await file.readAsBytes();
    imageWidget = Image.memory(dataUint8);
    // imageFile = File(file.path);
    // imageWidget = Image.memory(imageFile.readAsBytesSync());
    state = AppState.picked;
    debugPrint('stateIMAGEWEB: $state');
    notifyListeners();
  }

  Future<String> addImageToDb({@required BuildContext context}) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 1000, msg: '${'loading'.tr()} ${'image'.tr()}...');
    firebase_storage.UploadTask task;
    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final rng = Random();
    final _random = rng.nextInt(90000) + 10000;
    imageId = '$timeStamp-$_random}';
    debugPrint(
        'imageFile != null || dataUint8 != null: ${imageFile != null || dataUint8 != null}');
    if (imageFile != null || dataUint8 != null) {
      final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("$timeStamp-$_random.jpg");
      task = kIsWeb
          ? firebaseStorageRef.putData(dataUint8)
          : firebaseStorageRef.putFile(imageFile);
      await task.whenComplete(() {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // notifyListeners();
      }).then((value) async {
        final downUrl = await value.ref.getDownloadURL();
        debugPrint('DOWNURL: $downUrl');
        imageLink = downUrl;
        urlString = downUrl.toString();
        pr.close();
      });
      debugPrint("Url for Download: $urlString");
    }
    debugPrint('No imageFile, no dataUint8');
    return urlString;
  }

  Future cropImage() async {
    if (!kIsWeb) {
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
        state = AppState.cropped;
        notifyListeners();
      } else {
        state = AppState.empty;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void reset() {
    imageFile.delete();
    imageLink = '';
    urlString = '';
    imageId = '';
    imageLink = '';
    state = AppState.empty;
    notifyListeners();
  }
}
