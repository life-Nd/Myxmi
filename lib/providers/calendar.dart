import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarProvider =
    ChangeNotifierProvider<CalendarProvider>((ref) => CalendarProvider());
final calendarEventsProvider = ChangeNotifierProvider<CalendarEventsProvider>(
  (ref) => CalendarEventsProvider(),
);

class CalendarProvider extends ChangeNotifier {
  final Map<String, dynamic> _plan = {};
  String? recipeType;

  Map<String, dynamic> get plan => _plan;
  void changeRecipeType(String type) {
    recipeType = type;
    notifyListeners();
  }

  // void addPlan(RecipeModel recipe, List<DateTime> dateSelected) {
  //   for (final DateTime _date in dateSelected) {
  //     if (_plan[_date.toString()] == null) {
  //       _plan[_date.toString()] = [recipe];
  //     } else {
  //       _plan[_date].add(recipe);
  //     }
  //     _plan[recipe.recipeId] = recipe;
  //   }
  // }
}

class CalendarEventsProvider extends ChangeNotifier {
  String? yM;
  String? recipeType;
  String? recipeTitle;
  String? recipeImage;
  TimeOfDay time = TimeOfDay.now();
  List<CalendarEvent> events = [];

  void getEvents({required String date, required String title}) {
    final CalendarEvent _event = CalendarEvent(
      eventDate: DateTime.fromMillisecondsSinceEpoch(int.parse(date)),
      eventName: title,
      eventBackgroundColor: Colors.green,
    );
    events.add(_event);
  }

  void changeYM({required DateTime time}) {
    events = [];
    yM = '${time.year}-${time.month}';
  }
}
