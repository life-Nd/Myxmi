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
        final bool _detailsProvided = _recipe.recipesModel.title != null &&
            _recipe.recipesModel.category != null &&
            _recipe.recipesModel.subCategory != null;
        return RawMaterialButton(
          elevation: 20,
          fillColor: _detailsProvided ? Colors.blue : Colors.grey,
          onPressed: _detailsProvided
              ? () => tapNext()
              : () {
                  debugPrint('TITLE: ${_recipe.recipesModel.title}');
                  debugPrint('DIFFICULTY: ${_recipe.recipesModel.difficulty}');
                  debugPrint('DURATION: ${_recipe.recipesModel.duration}');
                  debugPrint('PORTIONS: ${_recipe.recipesModel.portions}');
                  debugPrint('CATEGORY: ${_recipe.recipesModel.category}');
                  debugPrint(
                      'SUBCATEGORY: ${_recipe.recipesModel.subCategory}');
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
