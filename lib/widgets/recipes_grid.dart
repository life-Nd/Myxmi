import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:flutter/foundation.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import '../main.dart';
import 'add_favorite.dart';
import 'rating_stars.dart';
import 'recipe_tile.dart';
import 'recipe_tile_image.dart';

class RecipesGrid extends StatefulWidget {
  final List<RecipeModel> recipes;
  final double height;
  const RecipesGrid({Key key, @required this.recipes, @required this.height})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    debugPrint('building recipes grid');

    return SizedBox(
      height: widget.height,
      width: _size.width,
      child: widget.recipes.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.6,
                crossAxisCount: kIsWeb && _size.width > 500 ? 4 : 2,
              ),
              padding: const EdgeInsets.all(1),
              itemCount: widget.recipes.length,
              itemBuilder: (_, int index) {
                return Consumer(builder: (_, watch, __) {
                  final _user = watch(userProvider);
                  final _recipeProvider = watch(recipeProvider);

                  final _recipe =
                      _recipeProvider.recipeModel = widget.recipes[index];
                  _recipe.liked = false;
                  if (_user?.account?.uid != null && _recipe.likedBy != null) {
                    final _uid = _user?.account?.uid;
                    _recipe.liked = _recipe.likedBy.containsKey(_uid) &&
                        _recipe.likedBy[_uid] == true;
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
                                const Icon(
                                  Icons.no_photography,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ],
                            );
                      _recipeProvider.recipeModel = widget.recipes[index];
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SelectedRecipe(
                              recipeModel: widget.recipes[index]),
                        ),
                      );
                    },
                    child: Container(
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
                    ),
                  );
                });
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/data_not_found.png'),
                Text(
                  'recipesEmpty'.tr(),
                ),
              ],
            ),
    );
  }
}
