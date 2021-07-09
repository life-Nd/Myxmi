import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import 'package:transparent_image/transparent_image.dart';

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
            ? FadeInImage.memoryNetwork(
                image: recipe.imageUrl,
                fit: BoxFit.fitWidth,
                imageCacheWidth: 1000,
                placeholder: kTransparentImage,
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/${recipe.subCategory}.jpg',
                      fit: BoxFit.fitWidth,
                      height: _size.height,
                      width: _size.width,
                      cacheWidth: 1000,
                      colorBlendMode: BlendMode.color,
                    ),
                  ),
                  const Icon(
                    Icons.no_photography,
                    size: 40,
                  ),
                ],
              );
        _recipeProvider.recipeModel = recipe;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SelectedRecipe(
                // recipe: _recipe,
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
            ? FadeInImage.memoryNetwork(
                image: recipe.imageUrl,
                fit: BoxFit.fitWidth,
                imageCacheWidth: 1000,
                placeholder: kTransparentImage,
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/${recipe.subCategory}.jpg',
                      fit: BoxFit.fitWidth,
                      height: _size.height,
                      width: _size.width,
                      cacheWidth: 1000,
                      colorBlendMode: BlendMode.color,
                    ),
                  ),
                  const Icon(
                    Icons.no_photography,
                    size: 40,
                  ),
                ],
              ),
      ),
    );
  }
}