import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/recipe_tile.dart';
import 'package:transparent_image/transparent_image.dart';
import '../app.dart';
import '../main.dart';
import 'selected_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class Favorites extends HookWidget {
  Widget build(BuildContext context) {
    final _fav = useProvider(favProvider);
    final _user = useProvider(userProvider);
    final _recipe = useProvider(recipeProvider);
    Map _data = _fav.showFiltered ? _fav.filtered : _fav.favorites;
    List _keys = _data.keys.toList();

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
          String _keyIndex = _keys[index];
          Map _indexData = _data[_keys[index]];
          print('FAVORITES: ${_data[_keys[index]]}');
          _recipe.details
              .fromSnapshot(keyIndex: _keys[index], snapshot: _indexData);
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              FirebaseFirestore.instance
                  .collection('Favorites')
                  .doc('${_user.account.uid}')
                  .update(
                {'$_keyIndex': FieldValue.delete()},
              );
              _fav.removeFavorites(newFavorite: _keyIndex);
              _change.value = !_change.value;
            },
            background: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'delete'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Icon(Icons.delete),
                  ],
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                _recipe.details.fromSnapshot(
                  keyIndex: _keyIndex,
                  snapshot: _indexData,
                );
                _recipe.image = FadeInImage.memoryNetwork(
                  image: '${_indexData['image_url']}',
                  fit: BoxFit.fitWidth,
                  imageCacheWidth: 1000,
                  placeholder: kTransparentImage,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SelectedRecipe(),
                  ),
                );
              },
              child: Container(
                height: _size.height / 2,
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
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage.memoryNetwork(
                        image: '${_details.imageUrl}',
                        fit: BoxFit.fitWidth,
                        imageCacheWidth: 1000,
                        placeholder: kTransparentImage,
                      ),
                    )),
                    RecipeTile(
                      recipes: _recipe.details,
                      type: 'Favorites',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
