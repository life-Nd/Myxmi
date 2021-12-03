import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/views/selectedRecipe/widgets/add_comments_view.dart';
import '../../../../utils/rating_stars.dart';

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
              // TODO Get the subcategory to show an asset image
              // in case the photoUrl wasnt uploaded
              subCategory: 'dinner',
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flexible(
                //   child: AddFavoriteButton(recipe: _recipe),
                // ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddComments(),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey.withOpacity(0.5),
                    elevation: 20,
                    child: RatingStars(
                      stars: _recipe.stars ?? '0.0',
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
    final Size _size = MediaQuery.of(context).size;
    final double _width = _size.width;
    final double _height = _size.height;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: imageUrl != null
          ? Image.network(
              imageUrl,
              fit: fitWidth ? BoxFit.fitWidth : BoxFit.values[4],
              cacheWidth: 1000,
              cacheHeight: 1000,
              height: _height,
              width: _width,
              errorBuilder: (context, child, error) {
                return const Center(child: CircularProgressIndicator());
              },
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
