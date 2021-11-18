import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/pages/add_comments.dart';
import 'package:sizer/sizer.dart';
import 'add_favorite.dart';
import 'rating_stars.dart';

class RecipeImage extends StatelessWidget {
  final RecipeModel recipe;
  final bool fitWidth;
  const RecipeImage({
    @required this.recipe,
    this.fitWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _recipe = recipe;

        return Stack(
          alignment: Alignment.topRight,
          children: [
            _RecipeImageClip(
              fitWidth: fitWidth,
              imageUrl: _recipe.imageUrl,
              subCategory: _recipe.subCategory,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: AddFavoriteButton(recipe: _recipe),
                ),
                const Spacer(),
                // const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddComments(),
                      ),
                    );
                  },
                  child: RatingStars(
                    stars: _recipe.stars ?? '0.0',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _RecipeImageClip extends HookWidget {
  final String imageUrl;
  final String subCategory;
  final bool fitWidth;
  const _RecipeImageClip({
    @required this.imageUrl,
    @required this.subCategory,
    @required this.fitWidth,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              // fit: BoxFit.fitWidth,
              fit: fitWidth ? BoxFit.fitWidth : BoxFit.values[4],
              cacheWidth: 1000,
              cacheHeight: 1000,
              height: 100.h,
              width: 100.w,
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.3,
                  child: subCategory != null
                      ? Image.asset(
                          'assets/$subCategory.jpg',
                          fit: BoxFit.fitWidth,
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
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.no_photography,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
    );
  }
}
