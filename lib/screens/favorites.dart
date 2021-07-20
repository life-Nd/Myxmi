import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/recipe_tile.dart';
import 'package:myxmi/widgets/recipe_tile_image.dart';
import '../app.dart';
import '../main.dart';



class Favorites extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _fav = useProvider(favProvider);
    final _user = useProvider(userProvider);
    final _change = useState<bool>(false);
    final Map _data = _fav.showFiltered ? _fav.filtered : _fav.allRecipes;
    final Size _size = MediaQuery.of(context).size;

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
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.6,
          crossAxisCount: kIsWeb ? 4 : 2,
        ),
        padding: const EdgeInsets.all(1),
        itemCount: _recipes.length,
        itemBuilder: (_, int index) {
          return Container(
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
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: _size.width / 2,
                        child: Hero(
                          tag: _recipes[index].recipeId,
                          child: RecipeTileImage(
                            recipe: _recipes[index],
                          ),
                        ),
                      ),
                    ),
                    RecipeTile(
                      type: 'Favorites',
                      recipe: _recipes[index],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Favorites')
                        .doc(_user.account.uid)
                        .update(
                      {_recipes[index].recipeId: FieldValue.delete()},
                    );
                    _fav.removeFavorite(newFavorite: _recipes[index].recipeId);
                    _change.value = !_change.value;
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
