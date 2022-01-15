import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/ingredients.dart';
import 'package:myxmi/screens/products/read/widgets/product_details.dart';

class IngredientsInRecipeListView extends StatelessWidget {
  final Map? ingredients;
  IngredientsInRecipeListView({@required this.ingredients});
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    final List _keys = ingredients!.keys.toList();

    bool _isText;
    String? _keyText;
    return Consumer(
      builder: (_, ref, child) {
        final _ingredients = ref.watch(ingredientsProvider);
        final List<String> _checkedIngredients =
            _ingredients.checkedIngredients;
        _ingredients.allIngredients = ingredients!;
        return ListView.builder(
          shrinkWrap: true,
          controller: _ctrl,
          itemCount: _keys.length,
          itemBuilder: (_, int index) {
            final String _key = _keys[index].toString();
            final _checked = _checkedIngredients.contains(_key);
            try {
              int.parse(
                _key,
              );
              _isText = false;
            } catch (error) {
              _isText = true;
              _keyText =
                  '${_key[0].toUpperCase()}${_key.substring(1, _key.length)}';
            }
            return ListTile(
              onTap: () {
                _ingredients.toggle(_key);
              },
              leading: IconButton(
                icon: _checked
                    ? const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      )
                    : const Icon(Icons.radio_button_unchecked),
                onPressed: () {
                  _ingredients.toggle(_key);
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isText)
                    Text(
                      '$_keyText',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      ': ${ingredients![_keys[index]]}',
                    ),
                  ),
                ],
              ),
              trailing: EditCartButton(
                name: _isText
                    ? '${_keys[index]} ${ingredients![_keys[index]]}'
                    : ingredients![_keys[index]] as String?,
              ),
            );
          },
        );
      },
    );
  }
}
