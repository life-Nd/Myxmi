import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:easy_localization/easy_localization.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

final imageProvider =
    ChangeNotifierProvider<ImageProvider>((ref) => ImageProvider());

enum AppState {
  empty,
  picked,
  cropped,
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

  SnackBar chooseImageSource(BuildContext context) {
    return SnackBar(
      elevation: 20,
      duration: const Duration(seconds: 777),
      content: SizedBox(
        height: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text(
              'chooseSource'.tr(),
              style: const TextStyle(fontSize: 17),
            )),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red,
                          Colors.purple,
                          Colors.blue,
                          Colors.white
                        ],
                      ),
                    ),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 20,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        pickImage(ImageSource.gallery).then(
                          (a) {
                            cropImage();
                          },
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'gallery'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const Icon(
                            Icons.image_search_sharp,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                            end: Alignment.topLeft,
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.red,
                              Colors.purple,
                              Colors.blue,
                              Colors.white
                            ])),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 20,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        pickImage(ImageSource.camera).then(
                          (a) {
                            cropImage();
                          },
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'camera'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 77);
    pickedFile != null ? pickedFile.readAsBytes() : debugPrint('Source Empty');
    pickedFile != null
        ? kIsWeb
            ? changeImageWeb(pickedFile)
            : changeImageFile(pickedFile)
        : debugPrint('No image selected');
    debugPrint("GetImage: $added");
    notifyListeners();
  }

  void changeImageFile(XFile file) {
    imageFile = File(file.path);
    imageWidget = Image.memory(imageFile.readAsBytesSync());
    state = AppState.picked;
    notifyListeners();
  }

  Future changeImageWeb(XFile file) async {
    dataUint8 = await file.readAsBytes();
    imageWidget = Image.memory(dataUint8);
    state = AppState.picked;
    notifyListeners();
  }

  Future addImageToDb(
      {String addedImage,
      BuildContext context,
      Uint8List data,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 1000, msg: '${'loading'.tr()} ${'image'.tr()}...');
    firebase_storage.UploadTask task;
    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final rng = Random();
    final _random = rng.nextInt(90000) + 10000;
    imageId = '$timeStamp-$_random}';
    if (imageFile != null || dataUint8 != null) {
      final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("$timeStamp-$_random.jpg");
      task = kIsWeb
          ? firebaseStorageRef.putData(dataUint8)
          : firebaseStorageRef.putFile(imageFile);
      await task.whenComplete(() {
        added = addedImage;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        debugPrint("AddImageToDb: $added");
        notifyListeners();
      }).then((value) async {
        final downUrl = await value.ref.getDownloadURL();
        debugPrint('DOWNURL: $downUrl');
        imageLink = downUrl;
        urlString = downUrl.toString();
        pr.close();
      });
      debugPrint("Url for Download: $urlString");
    }
    debugPrint('No image selected');
  }

// TODO Add image to db from web is not working

  Future cropImage() async {
    if (!kIsWeb && imageFile.path != null) {
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
      }
    }
  }

  void delete() {
    imageFile.delete();
    imageLink = '';
    urlString = '';
    imageId = '';
    imageLink = '';
    state = AppState.empty;
    notifyListeners();
  }
}
