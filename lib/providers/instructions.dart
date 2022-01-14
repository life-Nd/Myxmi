import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstructionsProvider extends ChangeNotifier {
  String view = 'List';
  List instructions = [];
  int pageViewIndex = 0;
  List<String> checked = [];
  PageController pageController = PageController();

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

  void setPageViewIndex(int index) {
    pageViewIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }
}

final instructionsProvider = ChangeNotifierProvider<InstructionsProvider>(
  (ref) => InstructionsProvider(),
);
