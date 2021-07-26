import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';

import 'add_favorite.dart';

class RecipeImage extends StatelessWidget {
  final double height;
  const RecipeImage(this.height);

  @override
  Widget build(BuildContext context) {
    debugPrint('Recipe image building');

    final Size _size = MediaQuery.of(context).size;
    return Expanded(
      child: Consumer(builder: (context, watch, child) {
        final _recipe = watch(recipeProvider);
        return Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              width: _size.width / 1,
              height: height / 1.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(child: _recipe.image),
              ),
            ),
            AddFavoriteButton(
              recipe: _recipe.recipeModel,
            ),
          ],
        );
      }),
    );
  }
}
