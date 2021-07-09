import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myxmi/models/recipe.dart';
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
    final Size _size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    final List<RecipeModel> _recipes = _data.entries.map((MapEntry data) {
      return RecipeModel.fromSnapshot(
        snapshot: data.value as Map<String, dynamic>,
        keyIndex: data.key as String,
      );
    }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        _fav.showFilter(value: false);
        _change.value = !_change.value;
      },
      child: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (_, int index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              FirebaseFirestore.instance
                  .collection('Favorites')
                  .doc(_user.account.uid)
                  .update(
                {_recipes[index].recipeId: FieldValue.delete()},
              );
              _fav.removeFavorite(newFavorite: _recipes[index].recipeId);
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
                //   _recipe.recipeModel.fromSnapshot(
                //     keyIndex: _keyIndex,
                //     snapshot: _indexData as Map<String, dynamic>,
                //   );
                //   _recipe.image = FadeInImage.memoryNetwork(
                //     image: '${_indexData['image_url']}',
                //     fit: BoxFit.fitWidth,
                //     imageCacheWidth: 1000,
                //     placeholder: kTransparentImage,
                //   );
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (_) => SelectedRecipe(
                //         recipe: _recipe.recipeModel,
                //       ),
                //     ),
                //   );
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
                      if (_recipes[index].difficulty == 'easy')
                        Colors.yellow.shade700
                      else
                        _recipes[index].difficulty == 'medium'
                            ? Colors.orange.shade900
                            : _recipes[index].difficulty == 'hard'
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
                      child: _recipes[index].imageUrl != null
                          ? FadeInImage.memoryNetwork(
                              image: _recipes[index].imageUrl,
                              fit: BoxFit.fitWidth,
                              imageCacheWidth: 1000,
                              placeholder: kTransparentImage,
                            )
                          : const Text('null'),
                    )),
                    RecipeTile(
                      type: 'Favorites',
                      recipe: _recipes[index],
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
