import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/widgets/added_images.dart';

class RecipeImage extends HookWidget {
  Widget build(BuildContext context) {
    final _image = useProvider(imageProvider);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        AddedImages(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).cardColor,
            child: Icon(
              Icons.add_a_photo,
              color: Theme.of(context).appBarTheme.titleTextStyle.color,
            ),
            onPressed: () => _image.chooseImageSource(context: context),
          ),
        ),
      ],
    );
  }
}
