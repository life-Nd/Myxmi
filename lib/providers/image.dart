import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:easy_localization/easy_localization.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

final imageProvider =
    ChangeNotifierProvider<ImageProvider>((ref) => ImageProvider());

class ImageProvider extends ChangeNotifier {
  File imageSample;
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
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 50, maxWidth: 320, maxHeight: 320);
    changeImageSample(pickedFile.path);
    debugPrint("GetImage: $added");
    notifyListeners();
  }

  void changeImageSample(String path) {
    imageSample = File(path);
    notifyListeners();
  }

  Future addImageToDb(
      {String addedImage,
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    firebase_storage.UploadTask task;
    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final rng = Random();
    final _random = rng.nextInt(90000) + 10000;
    pr.show(max: 1000, msg: '${'loading'.tr()} ${'image'.tr()}...');
    imageId = '$timeStamp-$_random}';

    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("$timeStamp-$_random.jpg");
    task = firebaseStorageRef.putFile(imageSample);
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

  void delete() {
    imageLink = '';
    urlString = '';
    imageId = '';
    imageLink = '';

    notifyListeners();
  }
}
