import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/models/recipes.dart';

class RecipeTileDetails extends HookWidget {
  final RecipeModel recipe;
  const RecipeTileDetails({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    final String _title =
        '${recipe?.title[0]?.toUpperCase()}${recipe?.title?.substring(1, recipe?.title?.length)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _title,
        ),
        Divider(
          color: Theme.of(context).appBarTheme.titleTextStyle.color,
          endIndent: 40,
        ),
        Row(
          children: [
            Text('${'ingredients'.tr()}: '),
            Text(
              recipe.ingredientsCount ?? '0',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Row(
          children: [
            Text('${'steps'.tr()}: '),
            Text(
              recipe?.stepsCount ?? '0',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.comment,
                  color: Colors.blue,
                  size: 15,
                ),
                Text(
                  recipe.reviewsCount ?? '0',
                  style: const TextStyle(fontSize: 17),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
