import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

class IngredientsInRecipeListView extends HookWidget {
  final Map ingredients;
  IngredientsInRecipeListView({this.ingredients});
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    // final _instructions = useProvider(ingredients);
    final List _keys = ingredients.keys.toList();
    final _change = useState<bool>(false);
    final _recipe = useProvider(recipeProvider);
    final _checkedIngredients = _recipe.checkedIngredients;
    bool _isText;
    return ListView.builder(
      shrinkWrap: true,
      controller: _ctrl,
      itemCount: _keys.length,
      itemBuilder: (_, int index) {
        final _checked = _checkedIngredients.contains(_keys[index]);
        try {
          int.parse(
            _keys[index].toString(),
          );
          _isText = false;
        } catch (error) {
          _isText = true;
        }
        return ListTile(
          onTap: () {
            _recipe.toggleIngredient(_keys[index]);
            _change.value = !_change.value;
          },
          leading: IconButton(
            icon: _checked
                ? const Icon(Icons.check_circle_outline)
                : const Icon(Icons.radio_button_unchecked),
            onPressed: () {
              _recipe.toggleIngredient(_keys[index]);
              _change.value = !_change.value;
            },
          ),
          title: Row(
            children: [
              if (_isText)
                Text(
                  '${_keys[index]}: ',
                ),
              Expanded(
                child: Text(
                  '${ingredients[_keys[index]]}',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
