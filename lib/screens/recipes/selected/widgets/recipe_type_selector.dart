import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/calendar_recipe_type.dart';

class RecipeTypeSelector extends StatelessWidget {
  const RecipeTypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _recipeTypeSelector = ref.watch(calendarRecipeTypeSelector);
        final String? _type = _recipeTypeSelector.type;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RawMaterialButton(
                  fillColor: _type == 'breakfast'
                      ? Colors.green
                      : Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    _recipeTypeSelector.changeType('breakfast');
                  },
                  elevation: 20.0,
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'breakfast'.tr(),
                    style: TextStyle(
                      color: _type == 'breakfast'
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
                RawMaterialButton(
                  fillColor: _type == 'supper'
                      ? Colors.green
                      : Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    _recipeTypeSelector.changeType('supper');
                  },
                  elevation: 20.0,
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'supper'.tr(),
                    style: TextStyle(
                      color: _type == 'supper'
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
                RawMaterialButton(
                  fillColor: _type == 'dinner'
                      ? Colors.green
                      : Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    _recipeTypeSelector.changeType('dinner');
                  },
                  elevation: 20.0,
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'dinner'.tr(),
                    style: TextStyle(
                      color: _type == 'dinner'
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
