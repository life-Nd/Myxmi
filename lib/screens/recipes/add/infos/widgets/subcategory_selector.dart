import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/recipes/add/infos/add_infos_screen.dart';
import 'package:myxmi/utils/selectable_row.dart';

class SubCategorySelector extends StatelessWidget {
  const SubCategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _recipe = ref.watch(recipeEntriesProvider);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('subCategory'.tr()),
            subCategory(
              category: _recipe.category,
            ),
          ],
        );
      },
    );
  }

  Widget subCategory({String? category}) {
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

class DrinksSubCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SelectableRow(
      textList: [
        'cocktail',
        'smoothie',
        'shake',
        'other',
      ],
      type: 'subcategory',
    );
  }
}

class FoodSubCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SelectableRow(
      textList: [
        'appetizer',
        'salad',
        'soup',
        'dinner',
        'dessert',
        'other',
      ],
      type: 'subcategory',
    );
  }
}

class VapeSubCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SelectableRow(
      textList: [
        'nicotine',
        'thc',
        'cbd',
        'other',
      ],
      type: 'subcategory',
    );
  }
}
