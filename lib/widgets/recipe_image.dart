import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'add_favorite.dart';
import 'add_reviews.dart';
import 'rating_stars.dart';

class RecipeImage extends StatelessWidget {
  final double height;
  const RecipeImage(this.height);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final _recipe = watch(recipeProvider);
      return SizedBox(
        width: _size.width,
        height: kIsWeb ? height : height / 1.7,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(child: _recipe.image),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AddFavoriteButton(recipe: _recipe.recipeModel),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddReviews(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RatingStars(
                      stars: _recipe.recipeModel.stars ?? '0.0',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
