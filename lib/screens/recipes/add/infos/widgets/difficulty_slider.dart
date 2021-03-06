import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/recipe_entries.dart';

class DifficultySlider extends StatelessWidget {
  const DifficultySlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _recipe = ref.watch(recipeEntriesProvider);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${'difficulty'.tr()}: '),
                Text(
                  _recipe.getDifficulty(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Slider(
              value: _recipe.difficultyValue,
              onChanged: (value) {
                _recipe.setDifficulty(value);
                debugPrint("VALUE: $value");
              },
              activeColor: _recipe.difficultyValue == 0.0
                  ? Colors.green
                  : _recipe.difficultyValue == 0.5
                      ? Colors.yellow
                      : _recipe.difficultyValue == 1.0
                          ? Colors.red
                          : Colors.grey,
              divisions: 2,
              label: _recipe.recipe.difficulty,
              inactiveColor: Colors.grey,
            ),
          ],
        );
      },
    );
  }
}
