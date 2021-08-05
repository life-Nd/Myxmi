import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/models/recipes.dart';

class RecipeTile extends HookWidget {
  final RecipesModel recipe;
  final String type;
  const RecipeTile({@required this.recipe, @required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          recipe?.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
            if (type == 'Category')
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
            else
              Container()
          ],
        ),
      ],
    );
  }
}
