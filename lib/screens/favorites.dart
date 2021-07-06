import 'package:myxmi/screens/add_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/recipe_list.dart';
import 'package:myxmi/widgets/recipe_tile.dart';
import 'package:transparent_image/transparent_image.dart';
import '../app.dart';

class Favorites extends HookWidget {
  Widget build(BuildContext context) {
    final _fav = useProvider(favProvider);
    Map _data = _fav.showFiltered ? _fav.filtered : _fav.favorites;
    List _keys = _data.keys.toList();
    final _recipe = useProvider(recipeProvider);
    final _details = _recipe.details;
    final Size _size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    return RefreshIndicator(
      onRefresh: () async {
        await _fav.showFilter(false);
        _change.value = !_change.value;
      },
      child: ListView.builder(
        itemCount: _keys.length,
        itemBuilder: (_, int index) {
          print('FAVORITES: ${_data[_keys[index]]}');
          _recipe.details.fromSnapshot(
              keyIndex: _keys[index], snapshot: _data[_keys[index]]);
          return Container(
            height: _size.height / 4,
            width: _size.width,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Theme.of(context).cardColor,
                  _details.difficulty == 'easy'
                      ? Colors.yellow.shade700
                      : _details.difficulty == 'medium'
                          ? Colors.orange.shade900
                          : _details.difficulty == 'hard'
                              ? Colors.red.shade700
                              : Colors.grey.shade700,
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                    child: FadeInImage.memoryNetwork(
                  image: '${_details.imageUrl}',
                  fit: BoxFit.fitHeight,
                  // imageCacheWidth: 1000,
                  placeholder: kTransparentImage,
                )),
                RecipeTile(
                  recipes: _recipe.details,
                  type: 'Favorites',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
