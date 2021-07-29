import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class IngredientsListView extends HookWidget {
  final List _checkedIngredients = [];
  final Map ingredients;
  IngredientsListView({this.ingredients});
  @override
  Widget build(BuildContext context) {
    final List _keys = ingredients.keys.toList();
    final Size _size = MediaQuery.of(context).size;
    final _change = useState<bool>(false);
    return SizedBox(
      height: _size.height / 2.1,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListView.builder(
            itemCount: _keys.length,
            itemBuilder: (_, int index) {
              final _checked = _checkedIngredients.contains(_keys[index]);
              return ListTile(
                onTap: () {
                  _checked
                      ? _checkedIngredients.remove(_keys[index])
                      : _checkedIngredients.add(_keys[index]);
                  _change.value = !_change.value;
                },
                leading: IconButton(
                  icon: _checked
                      ? const Icon(Icons.check_circle_outline)
                      : const Icon(Icons.radio_button_unchecked),
                  onPressed: () {
                    !_checked
                        ? _checkedIngredients.add(_keys[index])
                        : _checkedIngredients.remove(_keys[index]);
                    _change.value = !_change.value;
                  },
                ),
                title: Row(
                  children: [
                    Text(
                      '${_keys[index]}: ',
                    ),
                    Text(
                      '${ingredients[_keys[index]]}',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}