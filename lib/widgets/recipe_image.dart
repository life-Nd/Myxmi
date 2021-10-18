// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'add_favorite.dart';
import 'add_reviews.dart';
import 'rating_stars.dart';

class RecipeImage extends StatefulWidget {
  final double height;
  final BorderRadius borderRadius;
  const RecipeImage({@required this.height, @required this.borderRadius});
  @override
  State<StatefulWidget> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final _recipe = watch(recipeProvider);
      return SafeArea(
        child: SizedBox(
          width: _size.width,
          height: widget.height,
          child: Stack(
            children: [
              ClipRRect(
               borderRadius: widget.borderRadius,
                child: InteractiveViewer(
                  alignPanAxis: true,
                  child: _recipe.image,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: AddFavoriteButton(recipe: _recipe.recipeModel)),
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
        ),
      );
    });
  }
}
