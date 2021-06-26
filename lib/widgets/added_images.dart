import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/image.dart';

class AddedImages extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _image = useProvider(imageProvider);
    return _image.imageIds != null && _image.imageIds.length != 0
        ? Card(
            child: Image.network(
              _image.imageLinks[0],
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
            ),
          )
        : Container();
  }
}
