import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/widgets/added_images.dart';
import 'package:easy_localization/easy_localization.dart';

class RecipeImage extends HookWidget {
  Widget build(BuildContext context) {
    final _image = useProvider(imageProvider);
    return Column(
      children: [
        ListTile(
            title: Text(
              'images'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_a_photo,
              ),
              onPressed: () => _image.chooseImageSource(context: context),
            )),
        Spacer(),
        AddedImages(),
        Text('3/3')
      ],
    );
  }
}
