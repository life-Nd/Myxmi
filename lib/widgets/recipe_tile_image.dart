import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:myxmi/screens/selected_recipe.dart';

class RecipeTileImage extends HookWidget {
  final RecipeModel recipe;

  const RecipeTileImage({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    final _recipeProvider = useProvider(recipeProvider);
    final Size _size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        _recipeProvider.image = recipe.imageUrl != null
            ? Image.network(
                recipe.imageUrl,
                width: _size.width,
                height: _size.height,
                fit: BoxFit.fitWidth,
                cacheWidth: 1000,
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
                  const Icon(
                    Icons.no_photography,
                    color: Colors.red,
                    size: 40,
                  ),
                ],
              );
        _recipeProvider.recipeModel = recipe;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SelectedRecipe(
              recipeId: recipe.recipeId,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: recipe.imageUrl != null
            ? Image.network(
                recipe.imageUrl,
                fit: BoxFit.fitWidth,
                cacheWidth: 1000,
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: recipe.subCategory != null
                        ? Image.asset(
                            'assets/${recipe.subCategory}.jpg',
                            fit: BoxFit.fitHeight,
                            width: _size.width,
                            cacheWidth: 1000,
                            colorBlendMode: BlendMode.color,
                          )
                        : null,
                  ),
                  const Center(
                    child: Icon(
                      Icons.no_photography,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
