import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:flutter/foundation.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart';
import 'add_favorite.dart';
import 'rating_stars.dart';
import 'recipe_tile.dart';
import 'recipe_tile_image.dart';

class RecipesGrid extends StatelessWidget {
  final List<RecipeModel> recipes;
  const RecipesGrid({Key key, this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    debugPrint('building recipes grid');
    return SizedBox(
      height: _size.height / 1.2,
      width: _size.width / 1,
      child: recipes.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.6,
                crossAxisCount: kIsWeb ? 4 : 2,
              ),
              padding: const EdgeInsets.all(1),
              itemCount: recipes.length,
              itemBuilder: (_, int index) {
                return Consumer(builder: (_, watch, __) {
                  final _user = watch(userProvider);
                  final _recipeProvider = watch(recipeProvider);

                  final _recipe = _recipeProvider.recipeModel = recipes[index];
                  _recipe.liked = false;
                  if (_user?.account?.uid != null && _recipe.likedBy != null) {
                    final _uid = _user?.account?.uid;
                    _recipe.liked = _recipe.likedBy.containsKey(_uid) &&
                        _recipe.likedBy[_uid] == true;
                  }
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).cardColor,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: _size.width / 2,
                            child: Stack(
                              children: [
                                Hero(
                                  tag: _recipe.recipeId,
                                  child: RecipeTileImage(
                                    recipe: _recipe,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // TODO when tapping to add to favorites it shows a white screen
                                    AddFavoriteButton(recipe: _recipe),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RatingStars(
                                        stars: _recipe.stars ?? '0.0',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 7.0,
                            right: 10.0,
                          ),
                          child: RecipeTile(recipe: _recipe),
                        )
                      ],
                    ),
                  );
                });
              },
            )
          : Center(
              child: Text(
                'recipesEmpty'.tr(),
              ),
            ),
    );
  }
}
