import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FavoriteTile extends HookWidget {
  const FavoriteTile({
    Key key,
    @required this.indexData,
    @required this.index,
    @required this.newIndex,
    @required this.keyIndex,
  }) : super(key: key);

  final Map indexData;
  final int index;
  final int newIndex;
  final String keyIndex;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onLongPress: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (_) =>
        //       CommentsScreen(indexData: indexData, keyIndex: keyIndex),
        // ));
      },
      onTap: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        children: [
          Image.network('${indexData['image_url']}'),

        ],
      ),
    );
  }
}
