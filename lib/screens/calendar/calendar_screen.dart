import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/calendar_events.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/calendar/widgets/selected_recipe_card.dart';
import 'package:myxmi/screens/calendar/widgets/stats_row.dart';

/* TODO Planner should be changed to Calendar
 Calendar could be used to show
 Plan Meals (MEAL PLANNER)
 Track Meals (MEAL TRACKER)
 Read the same DB but separate
 the Plan Meals from the Track Meals
 by reading just the Done meals ($date: true) 
 in the Calendar Db 
*/
final calendarEventProvider = ChangeNotifierProvider<CalendarEventProvider>(
  (ref) => CalendarEventProvider(),
);

class CalendarScreen extends StatefulWidget {
  final bool showAppBar;
  const CalendarScreen({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text('calendar'.tr()),
            )
          : null,
      body: Consumer(
        builder: (_, ref, child) {
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                debugPrint('📡 Loading snapshot');
              }
              if (snapshot.data != null) {
                final Map<String, dynamic>? _events = snapshot.data!.data();
                if (_events != null && _events.keys.isNotEmpty) {
                  for (final _eventId in _events.keys) {
                    final Map _event = _events[_eventId] as Map;
                    final Map<String, dynamic>? _daysSelected =
                        _event['days'] as Map<String, dynamic>?;
                    if (_daysSelected != null) {
                      for (final String _day in _daysSelected.keys) {
                        final _allEvents = _event['days'] as Map;
                        final bool _done = _allEvents[_day] as bool;
                        Color _eventTextColor;
                        Color _eventBackgroundColor;
                        final bool _isPassed = !DateTime.now()
                            .compareTo(DateTime.parse(_day))
                            .isNegative;
                        if (_done) {
                          _eventTextColor = Colors.white;
                          _eventBackgroundColor = Colors.green;
                        } else if (_isPassed) {
                          _eventTextColor = Colors.white;
                          _eventBackgroundColor = Colors.red;
                        } else {
                          _eventTextColor =
                              Theme.of(context).textTheme.bodyText1!.color!;
                          _eventBackgroundColor = Theme.of(context).cardColor;
                        }
                        final _calendarProvider =
                            ref.read(calendarEventProvider);
                        _calendarProvider.addEvent(
                          CalendarEvent(
                            eventName:
                                '${_event['title'].toString().toUpperCase()},${_event['imageUrl']},$_done',
                            eventDate: DateTime.parse(_day),
                            eventID: _eventId,
                            eventTextColor: _eventTextColor,
                            eventBackgroundColor: _eventBackgroundColor,
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
                    child: Consumer(
                      builder: (_, ref, watch) {
                        final _calendarProvider =
                            ref.watch(calendarEventProvider);

                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CellCalendar(
                              events: _calendarProvider.allEvents,
                              onCellTapped: (date) {
                                final eventsOnTheDate = _calendarProvider
                                    .allEvents
                                    .where((element) {
                                  return DateFormat('dd-MM,' 'yyyy')
                                          .format(element.eventDate) ==
                                      DateFormat('dd-MM,' 'yyyy').format(date);
                                }).toList();
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          '${DateFormat('EEEE d MMM , ' 'yyyy').format(date)} '
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: const EdgeInsets.all(1),
                                      insetPadding: const EdgeInsets.all(10),
                                      content: SizedBox(
                                        height: 400,
                                        width: 400,
                                        child: ListView.builder(
                                          itemCount: eventsOnTheDate.length,
                                          itemBuilder: (_, int index) {
                                            return SelectedRecipeCard(
                                              event: eventsOnTheDate[index],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const StatsRow(),
                          ],
                        );
                      },
                    ),
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
