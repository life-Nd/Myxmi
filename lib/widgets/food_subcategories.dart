import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add.dart';
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
              _recipe.changeSubCategory(newSubCategory: 'Breakfast');
            },
            fillColor: _recipe.recipe.subCategory == 'Breakfast'
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
              _recipe.changeSubCategory(newSubCategory: 'Appetizer');
            },
            fillColor: _recipe.recipe.subCategory == 'Appetizer'
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
              _recipe.changeSubCategory(newSubCategory: 'Salad');
            },
            fillColor: _recipe.recipe.subCategory == 'Salad'
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
              _recipe.changeSubCategory(newSubCategory: 'Soup');
            },
            fillColor: _recipe.recipe.subCategory == 'Soup'
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
              _recipe.changeSubCategory(newSubCategory: 'Dinner');
            },
            fillColor: _recipe.recipe.subCategory == 'Dinner'
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
            fillColor: _recipe.recipe.subCategory == 'Dessert'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Dessert');
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
              _recipe.changeSubCategory(newSubCategory: 'Other');
            },
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
