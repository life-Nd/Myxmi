import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstructionsProvider extends ChangeNotifier {
  String view = 'List';
  List instructions = [];
  List<String> checked = [];

  void toggleView() {
    view = view == 'List' ? 'Page' : 'List';
    notifyListeners();
  }

  void toggleInstruction(String key) {
    debugPrint('toggleIngredient: $key');
    final bool _checked = checked.contains(key);
    if (_checked) {
      checked.remove(key);
    } else {
      checked.add(key);
    }
    notifyListeners();
  }
}

final instructionsProvider = ChangeNotifierProvider<InstructionsProvider>(
  (ref) => InstructionsProvider(),
);
