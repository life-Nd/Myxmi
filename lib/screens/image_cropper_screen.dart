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
              return Text('$title ');
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
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!kIsWeb && _image.state != AppState.empty)
              FloatingActionButton(
                onPressed: () {
                  _image.cropImage();
                },
                backgroundColor: Colors.deepOrange,
                child: const Icon(
                  Icons.crop,
                ),
              ),
            const SizedBox(height: 10),
            if (_image.state == AppState.empty)
              FloatingActionButton(
                onPressed: () {
                  _image.chooseImageSource(context);
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
              )
            else
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddRecipeInstructions(),
                    ),
                  );
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.save),
              ),
          ],
        ),
     
      );
    });
  }
}
