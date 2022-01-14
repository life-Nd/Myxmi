import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/utils/add_favorite.dart';
import 'package:myxmi/utils/calendar_button.dart';
import 'package:myxmi/utils/rating_stars.dart';
import 'package:myxmi/utils/share_button.dart';

class RecipeImage extends StatelessWidget {
  final RecipeModel recipe;
  final bool fitWidth;
  const RecipeImage({
    required this.recipe,
    required this.fitWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, child) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            _image(false),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CalendarButton(
                          recipe: recipe,
                          childRecipe: _image(true),
                        ),
                        AddFavoriteButton(recipe: recipe),
                        ShareButton(recipeId: recipe.recipeId),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Card(
                    color: Colors.grey.withOpacity(0.5),
                    elevation: 20,
                    child: RatingStars(
                      stars: recipe.stars ?? '0.0',
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _image(bool _fitWidth) {
    return _RecipeImageClip(
      imageUrl: recipe.imageUrl!,
      fitWidth: _fitWidth,
      title: recipe.title!,
      subCategory: 'dinner',
    );
  }
}

class _RecipeImageClip extends HookWidget {
  final String imageUrl;
  final String subCategory;
  final String title;
  final bool fitWidth;
  const _RecipeImageClip({
    required this.imageUrl,
    required this.subCategory,
    required this.title,
    required this.fitWidth,
  });
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    final double _height = _size.height;
    final CachedNetworkImage _image = CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
        ),
      ),
      height: _height,
      width: double.infinity,
      fit: fitWidth ? BoxFit.fitWidth : BoxFit.values[4],
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: imageUrl.isNotEmpty
          ? _image
          : Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.3,
                  child: subCategory.isNotEmpty
                      ? Image.asset(
                          'assets/$subCategory.jpg',
                          fit: BoxFit.fitWidth,
                          height: _height,
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
