import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import '../main.dart';
import 'add_favorite.dart';
import 'rating_stars.dart';
import 'recipe_tile.dart';
import 'recipe_tile_image.dart';

class RecipesGrid extends StatefulWidget {
  final List recipes;
  const RecipesGrid({Key key, @required this.recipes}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return widget.recipes.isNotEmpty
        ? GridView.builder(
            controller: _controller,
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
                final RecipeModel recipe = widget.recipes[index] as RecipeModel;
                // final _recipe =
                // _recipeProvider.recipeModel = widget.recipes[index];
                recipe.liked = false;
                if (_user?.account?.uid != null && recipe.likedBy != null) {
                  final _uid = _user?.account?.uid;
                  recipe.liked = recipe.likedBy.containsKey(_uid) &&
                      recipe.likedBy[_uid] == true;
                }
                return InkWell(
                  onTap: () {
                    _recipeProvider.image = recipe.imageUrl != null
                        ? Image.network(
                            recipe.imageUrl,
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
                                child: recipe.subCategory != null
                                    ? Image.asset(
                                        'assets/${recipe.subCategory}.jpg',
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
                    _recipeProvider.recipeModel =
                        widget.recipes[index] as RecipeModel;
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
                                  tag: recipe.recipeId,
                                  child: RecipeTileImage(
                                    recipe: recipe,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AddFavoriteButton(
                                      recipe: recipe,
                                      fromProvider: false,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RatingStars(
                                        stars: recipe.stars ?? '0.0',
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
                          child: RecipeTile(recipe: recipe),
                        )
                      ],
                    ),
                  ),
                );
              });
            },
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Image.asset('assets/data_not_found.png')),
              Expanded(
                child: Text(
                  'noRecipes'.tr(),
                ),
              ),
            ],
          );
  }
}
