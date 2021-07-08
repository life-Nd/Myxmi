import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class VapeSubCategories extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'nicotine');
            },
            fillColor: _recipe.recipeModel.subCategory == 'nicotine'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('nicotine'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'thc');
            },
            fillColor: _recipe.recipeModel.subCategory == 'thc'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('thc'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
               RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'cbd');
            },
            fillColor: _recipe.recipeModel.subCategory == 'cbd'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('cbd'.tr()),
          ),
          const SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'other');
            },
            fillColor: _recipe.recipeModel.subCategory == 'other'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text('other'.tr()),
          )
        ],
      ),
    );
  }
}
