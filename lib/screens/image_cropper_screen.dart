import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/screens/add_recipe_instructions.dart';

class ImageCropperScreen extends StatelessWidget {
  final String title;
  const ImageCropperScreen({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _image = watch(imageProvider);
      return Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (_, watch, __) {
              return const Text('title');
            },
          ),
          actions: _image.state != AppState.empty
              ? [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _image.delete(),
                  )
                ]
              : null,
        ),
        body: Center(
          child: _image.imageFile != null || _image.dataUint8 != null
              ? kIsWeb
                  ? Image.memory(_image.dataUint8)
                  : Image.memory(_image.imageFile.readAsBytesSync())
              : Container(),
        ),
        floatingActionButton: kIsWeb && _image.state == AppState.picked
            ? FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddRecipeInstructions(),
                    ),
                  );
                },
                child: const Icon(Icons.save),
              )
            : FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  debugPrint('_image.state: ${_image.state}');
                  debugPrint('_image.imageFile: ${_image.imageFile}');
                  if (_image.state == AppState.empty) {
                    _image.chooseImageSource(
                      context: context,
                      route: MaterialPageRoute(
                        builder: (_) => const ImageCropperScreen(
                          title: 'TESTING',
                        ),
                      ),
                    );
                  } else if (_image.state == AppState.picked) {
                    kIsWeb
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddRecipeInstructions(),
                            ),
                          )
                        : _image.cropImage();
                  } else if (_image.state == AppState.cropped) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddRecipeInstructions(),
                      ),
                    );
                  }
                },
                child: _image.buildButtonIcon(),
              ),
      );
    });
  }
}
