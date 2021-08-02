import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:easy_localization/easy_localization.dart';

class NextButton extends StatelessWidget {
  final Function tapNext;
  const NextButton({Key key, this.tapNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeProvider);
        final bool _detailsProvided = _recipe.recipeModel.title != null &&
            _recipe.recipeModel.category != null &&
            _recipe.recipeModel.subCategory != null;
        return RawMaterialButton(
          elevation: 20,
          fillColor: _detailsProvided ? Colors.blue : Colors.grey,
          onPressed: _detailsProvided
              ? () => tapNext()
              : () {
                  debugPrint('TITLE: ${_recipe.recipeModel.title}');
                  debugPrint('DIFFICULTY: ${_recipe.recipeModel.difficulty}');
                  debugPrint('DURATION: ${_recipe.recipeModel.duration}');
                  debugPrint('PORTIONS: ${_recipe.recipeModel.portions}');
                  debugPrint('CATEGORY: ${_recipe.recipeModel.category}');
                  debugPrint('SUBCATEGORY: ${_recipe.recipeModel.subCategory}');
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'next'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
