import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/user.dart';

final _calendarEventProvider = ChangeNotifierProvider<CalendarEventProvider>(
  (ref) => CalendarEventProvider(),
);

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, ref, child) {
          final _calendarProvider = ref.watch(_calendarEventProvider);
          final _user = ref.watch(userProvider);
          final _uid = _user.account!.uid;

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Calendar')
                .doc(_uid)
                .snapshots(),
            builder: (
              _,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.data != null) {
                final Map<String, dynamic>? _data = snapshot.data!.data();

                for (final _key in _data!.keys) {
                  final Map _event = _data[_key] as Map;
                  final Map<String, dynamic>? _daysSelected =
                      _event['days'] as Map<String, dynamic>?;

                  if (_daysSelected != null) {
                    for (final _month in _daysSelected.keys) {
                      final _monthData = _daysSelected[_month] as Map;
                      final List<String> _days =
                          _monthData.keys.toList() as List<String>;

                      for (final String _day in _days) {
                        _calendarProvider.addEvent(
                          CalendarEvent(
                            eventName: '${_event['title']}'.toUpperCase(),
                            eventDate: DateTime.parse(_day),
                            eventID: _event['recipeId'] as String,
                            eventTextColor: Colors.black,
                            eventBackgroundColor: _event['type'] == 'breakfast'
                                ? Colors.yellow.shade400
                                : _event['type'] == 'breakfast'
                                    ? Colors.orange.shade400
                                    : Colors.red.shade400,
                          ),
                        );
                      }
                    }
                  }
                }
              }
              return Column(
                children: [
                  Expanded(
                    child: CellCalendar(
                      events: _calendarProvider.events,
                      onCellTapped: (date) {
                        final _selected =
                            _calendarProvider.events.firstWhere((element) {
                          return DateFormat('dd-MM,' 'yyyy')
                                  .format(element.eventDate) ==
                              DateFormat('dd-MM,' 'yyyy').format(date);
                        });
                        _calendarProvider.selectEvent(_selected, date: date);
                      },
                    ),
                  ),
                  if (_calendarProvider.selectedEvent != null)
                    selectedRecipe(
                      _,
                      _calendarProvider.selectedDate!,
                      _calendarProvider.selectedEvent!,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

Widget selectedRecipe(
  BuildContext context,
  DateTime selectedDate,
  CalendarEvent calendarEvent,
) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            '${DateFormat('dd EEEE MMMM, ' 'yyyy').format(selectedDate).toUpperCase()} ',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).cardColor,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: SizedBox(
                    width: 77,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/breakfast.jpg'),
                    ),
                  ),
                  title: Text(calendarEvent.eventName),
                  subtitle: Text(calendarEvent.eventDate.toString()),
                  trailing: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class CalendarEventProvider extends ChangeNotifier {
  List<CalendarEvent> events = [];
  List<String?> eventIds = [];
  DateTime? selectedDate;
  CalendarEvent? selectedEvent;

  void addEvent(CalendarEvent event) {
    if (!eventIds.contains('${event.eventID}-${event.eventDate}')) {
      eventIds.add('${event.eventID}-${event.eventDate}');
      events.add(event);
    }
  }

  void selectEvent(CalendarEvent event, {DateTime? date}) {
    selectedEvent = event;
    selectedDate = date;
    notifyListeners();
  }
}
