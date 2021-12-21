import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarRecipeTypeSelector =
    ChangeNotifierProvider<CalendarRecipeTypeSelector>(
  (_) => CalendarRecipeTypeSelector(),
);

class CalendarRecipeTypeSelector extends ChangeNotifier {
  String? type;
  void changeType(String _type) {
    type = _type;
    notifyListeners();
  }
}
