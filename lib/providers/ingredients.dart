import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IngredientsProvider extends ChangeNotifier {
  Map allIngredients = {};
  List<String> checkedIngredients = [];

  void toggle(String key) {
    debugPrint('toggleIngredient: $key');
    final bool _checked = checkedIngredients.contains(key);
    if (_checked) {
      checkedIngredients.remove(key);
    } else {
      checkedIngredients.add(key);
    }
    notifyListeners();
  }
}

final ingredientsProvider = ChangeNotifierProvider<IngredientsProvider>(
  (ref) => IngredientsProvider(),
);
