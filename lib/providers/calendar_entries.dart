import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarEntriesProvider =
    ChangeNotifierProvider<CalendarEntriesProvider>((ref) {
  return CalendarEntriesProvider();
});

class CalendarEntriesProvider extends ChangeNotifier {
  Color? tileColor = Colors.grey;
  Color? textColor;
  String? type;
  DateTime? date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  bool showTimeSelector = false;

  void showTimeSelectorChanged() {
    showTimeSelector = !showTimeSelector;
    notifyListeners();
  }

  void changeTime(TimeOfDay newTime) {
    time = newTime;
    notifyListeners();
  }

  void changeColor(Color _tileColor, Color _textColor) {
    tileColor = _tileColor;
    textColor = _textColor;

    notifyListeners();
  }
}
