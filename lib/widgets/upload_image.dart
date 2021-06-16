import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/image.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class UploadImage extends HookWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String imageAdded;
  @override
  @override
  Widget build(BuildContext context) {
    final _image = useProvider(imageProvider);
    final Size size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.black,
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Expanded(
              child: _image.imageSample != null
                  ? Image.file(
                      _image.imageSample,
                      height: size.height,
                      width: size.width,
                    )
                  : Container(),
            ),
            _image.added == "No"
                ? RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    elevation: 7.0,
                    child: Text('add'.tr()),
                    fillColor: Colors.blue,
                    onPressed: () {
                      _image.addImageToDb(
                          addedImage: "Yes",
                          context: context,
                          scaffoldKey: _scaffoldKey);
                      _change.value = !_change.value;
                    },
                  )
                : Container(
                    child: Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.purple,
                    ),
                  ),
            fabCancelSave(
              context: context,
              imageHandler: _image.imageSample,
            ),
          ],
        ),
      ),
    );
  }
}

fabCancelSave({context, File imageHandler, dynamic previousScreen}) {
  return Container(
    alignment: Alignment.bottomLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          backgroundColor: Colors.red,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        imageHandler != null
            ? FloatingActionButton(
                backgroundColor: Colors.green,
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Container(),
      ],
    ),
  );
}
