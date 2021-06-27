import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/image.dart';

class AddedImages extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _image = useProvider(imageProvider);
    return _image.imageId != null 
        ? Card(
            child: Image.network(
              _image.imageLink,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
            ),
          )
        : Container();
  }
}
