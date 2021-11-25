import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/views/addRecipe/infos/add_infos_view.dart';

class NextButton extends StatelessWidget {
  final Function tapNext;
  const NextButton({Key key, this.tapNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Consumer(builder: (_, watch, child) {
        final _recipe = watch(recipeEntriesProvider);
        final bool _detailsProvided = _recipe.recipe.title != null &&
                _recipe.recipe.category != null &&
                _recipe.recipe.subCategory != null ||
            _recipe.recipe.category == 'other';

        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 20,
            fillColor: _detailsProvided ? Colors.blue : Colors.grey,
            onPressed: _detailsProvided ? () => tapNext() : () {},
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
          ),
        );
      }),
    );
  }
}
