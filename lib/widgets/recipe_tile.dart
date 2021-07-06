import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/models/recipes.dart';

class RecipeTile extends HookWidget {
  const RecipeTile({
    Key key,
    @required this.recipes,
    @required this.type
  }) : super(key: key);
  final RecipesModel recipes;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${recipes.title}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Divider(
          color: Theme.of(context).appBarTheme.titleTextStyle.color,
          endIndent: 40,
        ),
        Row(
          children: [
            Text('${'ingredients'.tr()}: '),
            Text(
              '${recipes.ingredientsCount}',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Row(
          children: [
            Text('${'steps'.tr()}: '),
            Text(
              '${recipes.stepsCount}',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Spacer(),
            type == 'All'
                ? Row(
                    children: [
                      Icon(
                        Icons.comment,
                        color: Colors.blue,
                        size: 15,
                      ),
                      Text(
                        '${recipes.reviewsCount}',
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
