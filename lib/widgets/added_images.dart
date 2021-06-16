import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/image.dart';

class AddedImages extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _image = useProvider(imageProvider);
    return _image.imageIds != null && _image.imageIds.length != 0
        ? Container(
            height: _size.height / 4,
            width: _size.width / 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _image.imageLinks.length,
              itemBuilder: (_, int index) {
                return Card(
                  child: Image.network(_image.imageLinks[index]),
                );
              },
            ),
          )
        : Container();
  }
}
