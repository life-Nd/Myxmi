import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/providers/image.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../app.dart';

class UploadUserPhoto extends HookWidget {
  Widget build(BuildContext context) {
    final _image = useProvider(imageProvider);
    final Size _size = MediaQuery.of(context).size;
    final _user = useProvider(userProvider);
    final ProgressDialog pr = ProgressDialog(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text('uploadImage'.tr()),
      ),
      body: Container(
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: InteractiveViewer(
          child: _image.imageSample != null
              ? Image.file(
                  _image.imageSample,
                  height: _size.height,
                  width: _size.width,
                )
              : Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            pr.show(max: 100, msg: '${'uploadingImage'.tr()} ...');
            _image.addImageToDb(context: context).whenComplete(() async {
              _user.account.updatePhotoURL(_image.imageLink).whenComplete(
                () {
                  _user.account.reload();
                  Future.delayed(Duration(seconds: 1), () {
                    pr.close();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => App(),
                      ),
                    );
                  });
                },
              );
            });
          }),
    );
  }
}
