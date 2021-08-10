import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/recipe.dart';
import 'add_favorite.dart';
import 'add_reviews.dart';
import 'rating_stars.dart';

class RecipeImage extends StatelessWidget {
  final double height;
  final RecipeProvider recipeProvider;
  const RecipeImage({@required this.height, @required this.recipeProvider});

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      return SizedBox(
        width: _size.width,
        height: kIsWeb ? height : height / 1.7,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(child: recipeProvider.image),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AddFavoriteButton(
                  recipe: recipeProvider.recipesModel,
                ),
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
                      stars: recipeProvider.recipesModel.stars ?? '0.0',
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
