import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/comments.dart';
import '../app.dart';
import '../main.dart';
import 'format_time.dart';
import 'view_composition.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoriteTile extends HookWidget {
  FavoriteTile(
      {Key key,
      @required this.indexData,
      @required this.index,
      @required this.newIndex,
      @required this.keys,
      @required this.keyIndex,
      @required this.time})
      : super(key: key);

  final Map indexData;
  final int index;
  final int newIndex;
  final List keys;
  final String keyIndex;
  final String time;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _user = useProvider(userProvider);
    final _fav = useProvider(favProvider);
    return ListTile(
      dense: true,
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>
              CommentsScreen(indexData: indexData, keyIndex: keyIndex),
        ));
      },
      onTap: () {
        viewComposition(
            context: context,
            user: _user,
            fav: _fav,
            indexData: indexData,
            keyIndex: keyIndex,
            size: _size);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // leading: CircleAvatar(
      //   backgroundColor: Colors.black,
      //   child: Center(
      //     child: Text(
      //       '$newIndex',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // ),
      title: Row(
        children: [
          Text('${indexData['Name']}'),
          Text(
            '  #${indexData['Reference']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20,
            width: _size.width,
            child: ListView.builder(
              itemCount: indexData['Composition'].keys.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(1),
              itemBuilder: (_, int index) {
                List _key = indexData['Composition'].keys.toList();
                return Center(
                  child: Text(
                      '${_key[index]}: ${indexData['Composition'][_key[index]]}, '),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${'liked'.tr()}: '),
              Expanded(
                child: Text(
                  '${formatTime('$time')}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
