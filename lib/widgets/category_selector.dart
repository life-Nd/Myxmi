import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeProvider);
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            fillColor: _recipe.recipeModel.category == 'drink'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeCategory(newCategory: 'drink');
            },
            child: Text('drink'.tr()),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            fillColor: _recipe.recipeModel.category == 'food'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeCategory(newCategory: 'food');
            },
            child: Text('food'.tr()),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            fillColor: _recipe.recipeModel.category == 'vapes'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeCategory(newCategory: 'vapes');
            },
            child: Text('vapes'.tr()),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            fillColor: _recipe.recipeModel.category == 'other'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeCategory(newCategory: 'other');
            },
            child: Text('other'.tr()),
          )
        ]);
      }),
    );
  }
}
