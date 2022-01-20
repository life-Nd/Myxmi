import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipe_image.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipe_tile_details.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';

class RecipeTile extends StatelessWidget {
  const RecipeTile({required this.recipes, required this.index, Key? key})
      : super(key: key);
  final List<RecipeModel?> recipes;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final _user = ref.watch(userProvider);
        final _recipeProvider = ref.watch(recipeDetailsProvider);
        final _recipe = recipes[index]!;
        final _router = ref.watch(routerProvider);
        _recipe.isLiked = false;
        if (_user.account?.uid != null && _recipe.likes != null) {
          final _uid = _user.account?.uid;
          _recipe.isLiked =
              _recipe.likes!.containsKey(_uid) && _recipe.likes![_uid] == true;
        }
        return InkWell(
          onTap: () {
            _recipeProvider.details = _recipe;
            _recipeProvider.image = RecipeImage(
              recipe: _recipe,
              fitWidth: true,
            );
            _recipeProvider.suggestedRecipes = recipes;

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
            child: RecipePreview(recipe: _recipe),
          ),
        );
      },
    );
  }
}

class RecipePreview extends StatelessWidget {
  const RecipePreview({
    Key? key,
    required RecipeModel recipe,
  })  : _recipe = recipe,
        super(key: key);

  final RecipeModel _recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              fitWidth: false,
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
    );
  }
}
