import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:easy_localization/easy_localization.dart';

import 'add_recipe.dart';

class RecipeImage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _image = useProvider(imageProvider);
    final _size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_image.imageSample != null)
          Container(
            height: _size.height / 1,
            margin:
                const EdgeInsets.only(top: 5, bottom: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).cardColor),
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.file(
                _image.imageSample,
                filterQuality: FilterQuality.medium,
                cacheWidth: 1000,
                cacheHeight: 1000,
                width: _size.width,
                fit: BoxFit.fitHeight,
              ),
            ),
          )
        else
          Center(
            child: Text('0 ${'image'.tr()}s'),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () => _image.chooseImageSource(
              context: context,
              route: MaterialPageRoute(
                builder: (_) => AddRecipe(),
              ),
            ),
            child: Icon(
              Icons.add_a_photo,
              color: Theme.of(context).appBarTheme.titleTextStyle.color,
            ),
          ),
        ),
      ],
    );
  }
}
