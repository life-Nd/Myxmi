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
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeProvider);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              fillColor: _recipe.recipeModel.category == 'drink'
                  ? Colors.green
                  : Theme.of(context).cardColor,
              onPressed: () {
                _recipe.changeCategory(newCategory: 'drink');
              },
              child: FittedBox(child: Text('drink'.tr())),
            ),
          ),
          RawMaterialButton(
            padding: const EdgeInsets.only(left: 8, right: 8),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawMaterialButton(
              padding: const EdgeInsets.only(left: 8, right: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              fillColor: _recipe.recipeModel.category == 'vapes'
                  ? Colors.green
                  : Theme.of(context).cardColor,
              onPressed: () {
                _recipe.changeCategory(newCategory: 'vapes');
              },
              child: Text('vapes'.tr()),
            ),
          ),
          Row(
            children: [
              RawMaterialButton(
                padding: const EdgeInsets.only(left: 8, right: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                fillColor: _recipe.recipeModel.category == 'other'
                    ? Colors.green
                    : Theme.of(context).cardColor,
                onPressed: () {
                  _recipe.changeCategory(newCategory: 'other');
                },
                child: Text('other'.tr()),
              ),
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
    });
  }
}
