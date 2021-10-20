import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';

class StepsListView extends HookWidget {
  final List steps;
  const StepsListView({this.steps});
  @override
  Widget build(BuildContext context) {
    final _change = useState<bool>(false);
  
    final _recipe = useProvider(recipeProvider);
    final _checkedSteps = _recipe.checkedSteps;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: steps.length,
      itemBuilder: (_, int index) {
        final _checked = _checkedSteps?.contains(steps[index]);
        return ListTile(
          onTap: () {
            _recipe.toggleStep(steps[index]);
            _change.value = !_change.value;
          },
          leading: IconButton(
            icon: _checked
                ? const Icon(Icons.check_circle_outline)
                : const Icon(Icons.radio_button_unchecked),
            onPressed: () {
              _recipe.toggleStep(steps[index]);
              _change.value = !_change.value;
            },
          ),
          title: Text(
            '${steps[index]}',
          ),
        );
      },
    );
  }
}
