import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/views/selectedRecipe/widgets/recipe_details.dart';
import '../../main.dart';
import '../views/recipes/widgets/recipe_image.dart';
import '../views/recipes/widgets/recipe_tile_details.dart';

class RecipeTile extends StatelessWidget {
  const RecipeTile({@required this.recipes, @required this.index, Key key})
      : super(key: key);
  final List<RecipeModel> recipes;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _user = watch(userProvider);
      final _recipeProvider = watch(recipeDetailsProvider);
      final _recipe = recipes[index];
      final _router = watch(routerProvider);
      _recipe.isLiked = false;
      if (_user?.account?.uid != null && _recipe.likes != null) {
        final _uid = _user?.account?.uid;
        _recipe.isLiked =
            _recipe.likes.containsKey(_uid) && _recipe.likes[_uid] == true;
      }
      return InkWell(
        onTap: () {
          _recipeProvider.details = _recipe;
          _recipeProvider.image = RecipeImage(
            recipe: _recipe,
            fitWidth: true,
          );
          _recipeProvider.suggestedRecipes = recipes;
          // TODO error with the implementation for this method
          //  in case the user changed the url from the SelectedRecipe
          //  it will not work because
          //  it would have two instances of the same page in the stack

          _router.pushPage(
            name: '/recipe',
            arguments: {'id': _recipe.recipeId},
          );
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).cardColor,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: RecipeImage(
                    recipe: _recipe,
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
