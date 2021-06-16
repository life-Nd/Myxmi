import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add.dart';
import 'package:easy_localization/easy_localization.dart';

class IngredientsCategories extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            child: Text('cocktail'.tr()),
            onPressed: () {},
            fillColor: _recipe.recipe.subCategory == 'Cocktail'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            child: Text('smoothie'.tr()),
            onPressed: () {},
            fillColor: _recipe.recipe.subCategory == 'Smoothie'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            child: Text('shake'.tr()),
            onPressed: () {},
            fillColor: _recipe.recipe.subCategory == 'Shake'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 7,
          ),
          RawMaterialButton(
            child: Text('other'.tr()),
            onPressed: () {},
            fillColor: _recipe.recipe.subCategory == 'Other'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }
}
