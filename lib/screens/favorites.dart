import 'package:myxmi/widgets/favorite_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../app.dart';

class Favorites extends HookWidget {
  Widget build(BuildContext context) {
    final _fav = useProvider(favProvider);
    Map _data = _fav.showFiltered ? _fav.filtered : _fav.favorites;
    List _keys = _data.keys.toList();
    final _change = useState<bool>(false);
    return RefreshIndicator(
      onRefresh: () async {
        await _fav.showFilter(false);
        _change.value = !_change.value;
      },
      child: ListView.builder(
        itemCount: _keys.length,
        itemBuilder: (_, int index) {
          int _newIndex = index + 1;
          Map _indexData = _data[_keys[index]];
          final Map _comments = {};
          final List _orderedComments = _comments.keys.toList();
          _orderedComments.sort();
          return Container(
            height: 60,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Theme.of(context).cardColor,
                  _indexData['Composition']['Use'] == 'Work'
                      ? Colors.yellow.shade400
                      : _indexData['Composition']['Use'] == 'Relax'
                          ? Colors.purple.shade900
                          : _indexData['Composition']['Use'] == 'Sleep'
                              ? Colors.blue.shade400
                              : Colors.grey.shade100,
                ],
              ),
            ),
            child: FavoriteTile(
              indexData: _indexData,
              keys: _keys,
              index: index,
              keyIndex: _data[index],
              newIndex: _newIndex,
              time: '${_indexData['Liked']}',
            ),
          );
        },
      ),

    );
  }
}
