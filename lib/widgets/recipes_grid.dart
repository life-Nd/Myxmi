import 'package:flutter/material.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:flutter/foundation.dart';
import 'add_favorite.dart';
import 'rating_stars.dart';
import 'recipe_tile.dart';
import 'recipe_tile_image.dart';

class RecipesGrid extends StatefulWidget {
  final List<RecipeModel> recipes;
  final String type;

  const RecipesGrid({@required this.recipes, @required this.type});
  @override
  State<StatefulWidget> createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  @override
  void initState() {
    _recipes();
    super.initState();
  }

  List<RecipeModel> _recipes() {
    return widget.recipes;
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SizedBox(
      height: _size.height / 1,
      width: _size.width / 1,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.6,
          crossAxisCount: kIsWeb ? 4 : 2,
        ),
        padding: const EdgeInsets.all(1),
        itemCount: _recipes().length,
        itemBuilder: (_, int index) {
          final RecipeModel _recipe = _recipes()[index];
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AddFavoriteButton(
                              recipe: _recipe,
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
                  child: RecipeTile(
                    type: widget.type,
                    recipe: _recipe,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
