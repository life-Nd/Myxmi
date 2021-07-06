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

  chooseImageSource(
      {@required BuildContext context, @required MaterialPageRoute route}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          title: Center(child: Text('${'chooseSource'.tr()}')),
          content: Container(
            height: 100,
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('${'gallery'.tr()}'),
                    SizedBox(
                      height: 7,
                    ),
                    FloatingActionButton(
                      child: Icon(
                        Icons.image,
                      ),
                      onPressed: () {
                        pickImage(ImageSource.gallery).then(
                          (a) {
                            Navigator.of(context).push(route);
                          },
                        );
                      },
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('${'camera'.tr()}'),
                    SizedBox(
                      height: 7,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: Center(
                        child: Icon(
                          Icons.image,
                        ),
                      ),
                      onPressed: () {
                        pickImage(ImageSource.camera).then(
                          (a) {
                            Navigator.of(context).push(route);
                          },
                        );
                      },
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
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);
    changeImageSample(pickedFile.path);
    print("GetImage: $added");
    notifyListeners();
  }

  changeImageSample(String path) {
    imageSample = File(path);
    notifyListeners();
  }

  Future addImageToDb(
      {String addedImage,
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    firebase_storage.UploadTask task;
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    var rng = new Random();
    var _random = rng.nextInt(90000) + 10000;
    pr.show(max: 100, msg: '${'loading'.tr()} ${'image'.tr()}...');
    imageId = '$timeStamp-$_random}';

    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("$timeStamp-$_random.jpg");
    task = firebaseStorageRef.putFile(imageSample);
    await task.whenComplete(() {
      added = addedImage;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      print("AddImageToDb: $added");
      notifyListeners();
    }).then((value) async {
      var downUrl = await value.ref.getDownloadURL();
      print('DOWNURL: $downUrl');
      imageLink = '$downUrl';
      urlString = downUrl.toString();
      pr.close();
    });
    print("Url for Download: $urlString");
  }

  void delete() {
    imageLink = '';
    urlString = '';
    imageId = '';
    imageLink = '';

    notifyListeners();
  }
}
