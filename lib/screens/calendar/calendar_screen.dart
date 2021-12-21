import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/user.dart';

final _calendarEventsProvider = ChangeNotifierProvider<CalendarEventsProvider>(
  (_) => CalendarEventsProvider(),
);

class CalendarScreen extends ConsumerStatefulWidget {
  final bool isEditing;
  const CalendarScreen({Key? key, required this.isEditing}) : super(key: key);
  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<CalendarEventData> _events = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _eventsProvider = ref.watch(_calendarEventsProvider);
        return CalendarControllerProvider<Object?>(
          controller: _eventsProvider.calendarController,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text('planner'.tr()),
              actions: [
                Consumer(
                  builder: (_, ref, child) {
                    final _calendarProvider =
                        ref.watch(_calendarEventsProvider);
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _calendarProvider.view = 'day';
                            });
                          },
                          icon: Icon(
                            Icons.calendar_view_day,
                            size: _calendarProvider.view == 'day' ? 25 : 20,
                            color: _calendarProvider.view == 'day'
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _calendarProvider.view = 'week';
                            });
                          },
                          icon: Icon(
                            Icons.calendar_view_week,
                            size: _calendarProvider.view == 'week' ? 25 : 20,
                            color: _calendarProvider.view == 'week'
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _calendarProvider.view = 'month';
                            });
                          },
                          icon: Icon(
                            Icons.calendar_view_month,
                            size: _calendarProvider.view == 'month' ? 25 : 20,
                            color: _calendarProvider.view == 'month'
                                ? Colors.green
                                : Colors.black,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
            body: Consumer(
              builder: (_, ref, child) {
                final _user = ref.watch(userProvider);
                final _calendarProvider = ref.watch(_calendarEventsProvider);
                final _uid = _user.account!.uid;
                return Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Calendar')
                            .doc('$_uid-${_calendarProvider.yearMonth}')
                            .snapshots(),
                        builder: (
                          _,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot,
                        ) {
                          if (snapshot.data != null) {
                            final _data = snapshot.data!.data();
                            final Map _daysSelected = _data?['days'] != null
                                ? _data!['days'] as Map
                                : {};

                            _daysSelected.forEach(
                              (k, v) {
                                final _date = DateTime(
                                  _calendarProvider.selectedDate!.year,
                                  _calendarProvider.selectedDate!.month,
                                  int.parse(
                                    k as String,
                                  ),
                                );
                                final _event = CalendarEventData(
                                  event: _data?['recipeId'],
                                  // start: _date,
                                  // end: _date,
                                  title: '${_data?['title']}',
                                  description: '${_data?['type']}',
                                  color: Colors.blue,
                                  date: _date,
                                );
                                if (!_events.contains(_event)) {
                                  _events.add(_event);
                                  _calendarProvider.calendarController
                                      .add(_event);
                                }
                              },
                            );
                          }
                          return MonthView(
                            headerBuilder: (date) {
                              debugPrint('date: $date');
                              return Center(
                                child: Text(
                                  DateFormat('MMMM ' 'yyyy')
                                      .format(_calendarProvider.selectedDate!)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            onEventTap: (event, date) =>
                                debugPrint(event.toString()),
                            cellBuilder: (date, events, isToday, isInMonth) {
                              List<CalendarEventData?> _dailyEvents = [];
                              // ignore: iterable_contains_unrelated_type
                              if (!_dailyEvents.contains(
                                _calendarProvider.calendarController,
                              )) {
                                _dailyEvents = _calendarProvider
                                    .calendarController
                                    .getEventsOnDay(date);
                              }
                              return Column(
                                children: [
                                  Center(
                                    child: Text(
                                      '${date.day}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _dailyEvents.length,
                                      itemBuilder: (_, int index) {
                                        return Card(
                                          color: Colors.blue.shade400,
                                          child: Text(
                                            '${_dailyEvents[index]!.title} ',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                            onPageChange: (DateTime time, index) {
                              _calendarProvider.changeMonth(time);
                            },
                            onCellTap: (List events, DateTime date) {
                              _calendarProvider.changeSelectedDate(date);
                            },
                          );
                        },
                      ),
                    ),
                    if (_calendarProvider.selectedDate != null)
                      Card(
                        child: Column(
                          children: [
                            Text(
                              '${_calendarProvider.selectedDate!.day} ${_calendarProvider.selectedDate!.month} ${_calendarProvider.selectedDate!.year}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _calendarProvider.yearMonth,
                                ),
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
                                        child: Image.asset(
                                          'assets/rice.jpg',
                                        ),
                                      ),
                                    ),
                                    title: const Text('Eggs'),
                                    subtitle: const Text('1 dozen'),
                                    trailing: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CalendarEventsProvider extends ChangeNotifier {
  String view = 'month';
  String yearMonth = '${DateTime.now().year}-${DateTime.now().month}';
  DateTime? selectedDate;
  DateTime? visibleDate;
  EventController calendarController = EventController();
  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void changeView(String _view) {
    view = _view;
    notifyListeners();
  }

  void changeMonth(DateTime? date) {
    yearMonth = '${date!.year}-${date.month}';
    // calendarController.events.clear();

    notifyListeners();
  }
}
