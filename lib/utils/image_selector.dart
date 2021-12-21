import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myxmi/providers/image.dart';

class ImageSelector extends HookWidget {
  final VoidCallback onComplete;
  const ImageSelector({required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(2),
      icon: const Icon(
        Icons.add_a_photo,
        size: 25,
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 20,
            duration: const Duration(seconds: 777),
            content: SizedBox(
              height: 110,
              child: Consumer(
                builder: (_, ref, __) {
                  final _image = ref.watch(imageProvider);
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              'chooseSource'.tr(),
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 20,
                                  child: InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      _image
                                          .pickImage(ImageSource.gallery)
                                          .whenComplete(
                                        () {
                                          _image.cropImage().then(
                                            (value) {
                                              if (value != null) {
                                                if (_image.state ==
                                                    AppState.cropped) {
                                                  onComplete();
                                                } else {
                                                  debugPrint('nothing cropped');
                                                }
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'gallery'.tr(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          const Icon(
                                            Icons.image_search_sharp,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 20,
                                  child: InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      _image.pickImage(ImageSource.camera).then(
                                        (a) {
                                          _image.cropImage().then(
                                            (value) {
                                              if (value != null) {
                                                if (_image.state ==
                                                    AppState.cropped) {
                                                  onComplete();
                                                } else {
                                                  debugPrint('nothing cropped');
                                                }
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'camera'.tr(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          const Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
