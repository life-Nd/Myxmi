import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/calendar.dart';

class RecipeTypeSelector extends StatelessWidget {
  const RecipeTypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _calendar = ref.watch(calendarProvider);
        final String? _type = _calendar.recipeType;
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
                    _calendar.changeRecipeType('breakfast');
                  },
                  elevation: 20.0,
                  padding: const EdgeInsets.all(15.0),
                  child: Text('breakfast'.tr()),
                ),
                RawMaterialButton(
                  fillColor: _type == 'supper'
                      ? Colors.green
                      : Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    _calendar.changeRecipeType('supper');
                  },
                  elevation: 20.0,
                  padding: const EdgeInsets.all(15.0),
                  child: Text('supper'.tr()),
                ),
                RawMaterialButton(
                  fillColor: _type == 'dinner'
                      ? Colors.green
                      : Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    _calendar.changeRecipeType('dinner');
                  },
                  elevation: 20.0,
                  padding: const EdgeInsets.all(15.0),
                  child: Text('dinner'.tr()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
