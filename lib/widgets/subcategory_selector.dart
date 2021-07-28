import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

import 'drinks_subcategories.dart';
import 'food_subcategories.dart';
import 'vape_subcategories.dart';

class SubCategorySelector extends StatelessWidget {
  Widget subCategory({String category}) {
    Widget _subCategory;
    switch (category) {
      case 'food':
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('subCategory'.tr()),
            Row(
              children: [
                FoodSubCategories(),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        ' ${'required'.tr()}',
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
        return _subCategory;
      case 'drink':
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('subCategory'.tr()),
            Row(
              children: [
                DrinksSubCategories(),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        ' ${'required'.tr()}',
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
        return _subCategory;
      case 'vapes':
        _subCategory = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('subCategory'.tr()),
            Row(
              children: [
                VapeSubCategories(),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        ' ${'required'.tr()}',
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
        return _subCategory;
      default:
        _subCategory = Container();
        return _subCategory;
    }
  }

  const SubCategorySelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeProvider);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          subCategory(
            category: _recipe.recipeModel.category,
          ),
        ],
      );
    });
  }
}
