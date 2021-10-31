import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/selected_recipe.dart';

import '../main.dart';
import 'add_favorite.dart';
import 'rating_stars.dart';
import 'recipe_tile_details.dart';
import 'recipe_tile_image.dart';

class RecipeTile extends StatelessWidget {
  const RecipeTile({@required this.recipes, @required this.index, Key key})
      : super(key: key);
  final List<RecipeModel> recipes;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _user = watch(userProvider);
      final _recipeProvider = watch(recipeProvider);
      final _recipe = recipes[index];
      final _size = MediaQuery.of(context).size;
      _recipe.liked = false;
      if (_user?.account?.uid != null && _recipe.likedBy != null) {
        final _uid = _user?.account?.uid;
        _recipe.liked =
            _recipe.likedBy.containsKey(_uid) && _recipe.likedBy[_uid] == true;
      }
      return InkWell(
        onTap: () {
          _recipeProvider.image = _recipe.imageUrl != null
              ? Image.network(
                  _recipe.imageUrl,
                  width: _size.width,
                  height: _size.height,
                  fit: BoxFit.fitWidth,
                  cacheWidth: 1000,
                  cacheHeight: 1000,
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.3,
                      child: _recipe.subCategory != null
                          ? Image.asset(
                              'assets/${_recipe.subCategory}.jpg',
                              fit: BoxFit.fitWidth,
                              height: _size.height,
                              width: _size.width,
                              cacheWidth: 1000,
                              cacheHeight: 1000,
                              colorBlendMode: BlendMode.color,
                            )
                          : const Icon(
                              Icons.no_photography,
                              color: Colors.red,
                            ),
                    ),
                    Container(
                      width: _size.width,
                      height: _size.height,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.no_photography,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                );
          _recipeProvider.recipe = _recipe;
          _recipeProvider.suggestedRecipes = recipes;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SelectedRecipe()),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(4),
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
                  width: _size.width,
                  child: Stack(
                    children: [
                      Hero(
                        tag: _recipe.recipeId,
                        child: RecipeTileImage(
                          recipe: _recipe,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AddFavoriteButton(
                            recipe: _recipe,
                            fromProvider: false,
                          ),
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
                child: RecipeTileDetails(recipe: _recipe),
              )
            ],
          ),
        ),
      );
    });
  }
}
