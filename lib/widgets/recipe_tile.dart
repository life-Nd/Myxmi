import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';

class RecipeTile extends HookWidget {
  RecipeTile({
    Key key,
    @required this.indexData,
  }) : super(key: key);

  final Map indexData;

  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${indexData['title']}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Divider(
          color: Colors.black,
          endIndent: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Row(
            children: [
              Text('${'ingredients'.tr()}: '),
              Text(
                '${_recipe.details.productsCount}',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Row(
            children: [
              Text('${'steps'.tr()}: '),
              Text(
                '${_recipe.details.stepsCount}',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Spacer(),
              Icon(
                Icons.comment,
                color: Colors.blue,
                size: 15,
              ),
              Text(
                '${_recipe.details.comments}',
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
      ],
    );
  }
}
