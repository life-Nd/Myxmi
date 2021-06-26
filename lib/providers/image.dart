import 'dart:io';
import 'dart:math';
import 'package:myxmi/widgets/upload_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:easy_localization/easy_localization.dart';

final imageProvider =
    ChangeNotifierProvider<ImageProvider>((ref) => ImageProvider());

class ImageProvider extends ChangeNotifier {
  File imageSample;
  String urlString;
  List<String> imageLinks = [];
  List<String> imageIds = [];
  String added;
  final picker = ImagePicker();

  chooseImageSource({@required BuildContext context}) {
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
                        getImage(ImageSource.camera).then(
                          (a) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UploadImage(),
                              ),
                            );
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
                        getImage(ImageSource.camera).then(
                          (a) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UploadImage(),
                              ),
                            );
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

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);
    added = "No";
    imageSample = File(pickedFile.path);
    print("GetImage: $added");
    notifyListeners();
  }

  addImageToDb(
      {String addedImage,
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    firebase_storage.UploadTask task;
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    var rng = new Random();
    var _random = rng.nextInt(9000) + 1000;
    imageIds.add('$timeStamp-$_random}');

    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("$timeStamp-$_random.jpg");
    task = firebaseStorageRef.putFile(imageSample);
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            title: new LinearProgressIndicator(
              backgroundColor: Colors.black,
              valueColor: AlwaysStoppedAnimation(Colors.red),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
    task.whenComplete(() {
      added = addedImage;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      print("AddImageToDb: $added");
      notifyListeners();
    }).then((value) async {
      var downUrl = await value.ref.getDownloadURL();
      print("DOWNURL: $downUrl");
      imageLinks.add("$downUrl");
      urlString = downUrl.toString();
    });

    print("Url for Download: $urlString");
  }

  void delete() {
    imageLinks = [];
    urlString = "";
    imageIds = [];
    imageLinks = [];

    notifyListeners();
  }
}
