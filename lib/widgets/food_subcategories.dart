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
            child: Text('breakfasts'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Breakfasts');
            },
            fillColor: _recipe.details.subCategory == 'Breakfasts'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('appetizers'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Appetizers');
            },
            fillColor: _recipe.details.subCategory == 'Appetizers'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('salads'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Salads');
            },
            fillColor: _recipe.details.subCategory == 'Salads'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('soups'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Soups');
            },
            fillColor: _recipe.details.subCategory == 'Soups'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('dinners'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Dinners');
            },
            fillColor: _recipe.details.subCategory == 'Dinners'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('desserts'.tr()),
            fillColor: _recipe.details.subCategory == 'Desserts'
                ? Colors.green
                : Theme.of(context).cardColor,
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Desserts');
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
            fillColor: _recipe.details.subCategory == 'Other'
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
