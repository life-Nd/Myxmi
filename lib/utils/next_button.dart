import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/recipes/add/infos/add_infos_screen.dart';

class NextButton extends StatelessWidget {
  final Function() tapNext;
  const NextButton({Key? key, required this.tapNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Consumer(
        builder: (_, ref, child) {
          final _recipe = ref.watch(recipeEntriesProvider);
          final bool _detailsProvided = _recipe.recipe.title != '' &&
                  _recipe.category != '' &&
                  _recipe.subCategory != '' ||
              _recipe.category == 'other';
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 20,
              fillColor: _detailsProvided ? Colors.blue : Colors.grey,
              // TODO CHANGED THE BUTTON TEXT
              onPressed: _detailsProvided ? () => tapNext() : () {},
              // TO
              // onPressed: _detailsProvided ? () => tapNext : () {},
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
        },
      ),
    );
  }
}
