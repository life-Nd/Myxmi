import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';

class VapeSubCategories extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            child: Text('Nicotine'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'Nicotine');
            },
            fillColor: _recipe.details.subCategory == 'Nicotine'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
          RawMaterialButton(
            child: Text('THC'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'THC');
            },
            fillColor: _recipe.details.subCategory == 'THC'
                ? Colors.green
                : Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 4,
          ),
               RawMaterialButton(
            child: Text('CBD'.tr()),
            onPressed: () {
              _recipe.changeSubCategory(newSubCategory: 'CBD');
            },
            fillColor: _recipe.details.subCategory == 'CBD'
                ? Colors.green
                : Theme.of(context).cardColor,
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
