import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_infos_to_recipe.dart';
import 'package:sizer/sizer.dart';

import 'drinks_subcategories.dart';
import 'food_subcategories.dart';
import 'vape_subcategories.dart';

class SubCategorySelector extends StatelessWidget {
  const SubCategorySelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeProvider);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('subCategory'.tr()),
          SizedBox(
            width: 100.w,
            height: 7.h,
            child: Center(
              child: subCategory(
                category: _recipe.recipe.category,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget subCategory({String category}) {
    Widget _subCategory;
    switch (category) {
      case 'food':
        _subCategory = FoodSubCategories();
        return _subCategory;
      case 'drink':
        _subCategory = DrinksSubCategories();
        return _subCategory;
      case 'vapes':
        _subCategory = VapeSubCategories();
        return _subCategory;
      default:
        _subCategory = Container();
        return _subCategory;
    }
  }
}
