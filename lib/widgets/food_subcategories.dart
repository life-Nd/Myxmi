import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class FoodSubCategories extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            child: Text('breakfast'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'breakfast');
            },
            fillColor: _recipe.details.subCategory == 'breakfast'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('appetizer'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'appetizer');
            },
            fillColor: _recipe.details.subCategory == 'appetizer'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('salad'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'salad');
            },
            fillColor: _recipe.details.subCategory == 'salad'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('soup'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'soup');
            },
            fillColor: _recipe.details.subCategory == 'soup'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('dinner'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'dinner');
            },
            fillColor: _recipe.details.subCategory == 'dinner'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('dessert'.tr()),
            fillColor: _recipe.details.subCategory == 'dessert'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'dessert');
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('other'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'other');
            },
            fillColor: _recipe.details.subCategory == 'other'
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
