import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/recipe_tile.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:easy_localization/easy_localization.dart';
import '../app.dart';
import '../main.dart';


class Favorites extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _fav = useProvider(favProvider);
    final _user = useProvider(userProvider);
    final Map _data = _fav.showFiltered ? _fav.filtered : _fav.allRecipes;
    final List _keys = _data.keys.toList();
    final Size _size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    final _recipe = useProvider(recipeProvider);
    final _details = _recipe.recipeModel;
    return RefreshIndicator(
      onRefresh: () async {
        _fav.showFilter(value: false);
        _change.value = !_change.value;
      },
      child: ListView.builder(
        itemCount: _keys.length,
        itemBuilder: (_, int index) {
          debugPrint('KEYINDEX: ${_keys[index]}');
          final String _keyIndex = '${_keys[index]}';
          // final Map _indexData = _data[_keys[index]] as Map;
          debugPrint('FAVORITES: ${_data[_keys[index]]}');
          // _recipe.recipeModel.fromSnapshot(
          //     keyIndex: _keys[index] as String,
          //     snapshot: _indexData as Map<String, dynamic>);
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              FirebaseFirestore.instance
                  .collection('Favorites')
                  .doc(_user.account.uid)
                  .update(
                {_keyIndex: FieldValue.delete()},
              );
              _fav.removeFavorite(newFavorite: _keyIndex);
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    const Icon(Icons.delete),
                  ],
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                // _recipe.recipeModel.fromSnapshot(
                //   keyIndex: _keyIndex,
                //   snapshot: _indexData as Map<String, dynamic>,
                // );
                // _recipe.image = FadeInImage.memoryNetwork(
                //   image: '${_indexData['image_url']}',
                //   fit: BoxFit.fitWidth,
                //   imageCacheWidth: 1000,
                //   placeholder: kTransparentImage,
                // );
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => SelectedRecipe(
                //       recipe: _recipe.recipeModel,
                //     ),
                //   ),
                // );
              },
              child: Container(
                height: _size.height / 2,
                width: _size.width,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).cardColor,
                      if (_details.difficulty == 'easy')
                        Colors.yellow.shade700
                      else
                        _details.difficulty == 'medium'
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
                        image: _details.imageUrl,
                        fit: BoxFit.fitWidth,
                        imageCacheWidth: 1000,
                        placeholder: kTransparentImage,
                      ),
                    )),
                    RecipeTile(
                      type: 'Favorites',
                      recipe: _details,
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
