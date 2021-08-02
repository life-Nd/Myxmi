import 'dart:io';
import 'dart:math';
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
  String urlString;
  String imageLink = '';
  String imageId = '';
  String added;
  final picker = ImagePicker();

  void chooseImageSource(
      {@required BuildContext context, @required MaterialPageRoute route}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          title: Center(child: Text('chooseSource'.tr())),
          content: SizedBox(
            height: 100,
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('gallery'.tr()),
                    const SizedBox(
                      height: 7,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery).then(
                          (a) {
                            Navigator.of(context).push(route);
                          },
                        );
                      },
                      child: const Icon(
                        Icons.image,
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('camera'.tr()),
                    const SizedBox(
                      height: 7,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        pickImage(ImageSource.camera).then(
                          (a) {
                            Navigator.of(context).push(route);
                          },
                        );
                      },
                      child: const Center(
                        child: Icon(
                          Icons.image,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 77);
    pickedFile != null
        ? changeimageFile(pickedFile.path)
        : debugPrint('No image selected');
    debugPrint("GetImage: $added");
    notifyListeners();
  }

  void changeimageFile(String path) {
    imageFile = File(path);
    state = AppState.picked;
    notifyListeners();
  }

  Widget buildButtonIcon() {
    if (state == AppState.empty) {
      return const Icon(Icons.add);
    } else if (state == AppState.picked) {
      return const Icon(Icons.crop);
    } else if (state == AppState.cropped) {
      return const Icon(Icons.save);
    } else {
      return Container();
    }
  }

  Future addImageToDb(
      {String addedImage,
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 1000, msg: '${'loading'.tr()} ${'image'.tr()}...');
    firebase_storage.UploadTask task;
    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final rng = Random();
    final _random = rng.nextInt(90000) + 10000;
    imageId = '$timeStamp-$_random}';
    if (imageFile != null) {
      final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("$timeStamp-$_random.jpg");
      task = firebaseStorageRef.putFile(imageFile);
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

  Future cropImage() async {
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
