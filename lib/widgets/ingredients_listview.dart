import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import '../main.dart';
import 'product_details.dart';

class IngredientsInRecipeListView extends HookWidget {
  final Map ingredients;
  IngredientsInRecipeListView({this.ingredients});
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    final List _keys = ingredients.keys.toList();
    final _change = useState<bool>(false);
    final _recipe = useProvider(recipeProvider);
    final _user = useProvider(userProvider);
    final _checkedIngredients = _recipe.checkedIngredients;
    bool _isText;
    String _keyText;
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
          final String _key = _keys[index].toString();
          _keyText =
              '${_key[0].toUpperCase()}${_key.substring(1, _key.length)}';
        }
        return Column(
          children: [
            ListTile(
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isText)
                    Text(
                      '$_keyText: ',
                    ),
                  Expanded(
                    child: Text(
                      '${ingredients[_keys[index]]}',
                    ),
                  ),
                ],
              ),
              trailing:
                  EditCartButton(name: ingredients[_keys[index]] as String),
            ),
            if (_user.onPhone)
              const Divider(
                indent: 80,
                color: Colors.grey,
              )
          ],
        );
      },
    );
  }
}
