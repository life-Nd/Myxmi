import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:easy_localization/easy_localization.dart';

class DifficultySlider extends StatelessWidget {
  const DifficultySlider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeProvider);
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${'difficulty'.tr()}: '),
              Text(
                _recipe.getDifficulty(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          Slider(
            value: _recipe.difficultyValue,
            onChanged: (value) {
              _recipe.changeDifficulty(value);
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
            label: _recipe.recipeModel.difficulty,
            inactiveColor: Colors.grey,
          ),
        ],
      );
    });
  }
}
