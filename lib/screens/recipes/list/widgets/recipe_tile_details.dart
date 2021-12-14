import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myxmi/models/recipe.dart';

class RecipeTileDetails extends HookWidget {
  final RecipeModel recipe;
  const RecipeTileDetails({required this.recipe});

  @override
  Widget build(BuildContext context) {
    String _title = '';
    if (recipe.title != null) {
      _title =
          '${recipe.title![0].toUpperCase()}${recipe.title?.substring(1, recipe.title?.length)}';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _title,
          ),
          Divider(
            color: Theme.of(context).textTheme.bodyText1!.color,
            endIndent: 40,
          ),
          Row(
            children: [
              Text('${'ingredients'.tr()}: '),
              Expanded(
                child: Text(
                  recipe.ingredientsCount ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('${'steps'.tr()}: '),
              Expanded(
                child: Text(
                  recipe.instructionsCount ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.comment,
                      color: Colors.blue,
                      size: 15,
                    ),
                    Expanded(
                      child: Text(
                        recipe.commentsCount ?? '0',
                        style: const TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
