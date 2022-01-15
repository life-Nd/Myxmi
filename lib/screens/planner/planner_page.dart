import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';

/* TODO Planner should be changed to Calendar
 Calendar could be used to show
 Plan Meals (MEAL PLANNER)
 Track Meals (MEAL TRACKER)
 Read the same DB but separate
 the Plan Meals from the Track Meals
 by reading just the Done meals ($date: true) 
 in the Calendar Db 
*/
final _calendarEventProvider = ChangeNotifierProvider<CalendarEventProvider>(
  (ref) => CalendarEventProvider(),
);

class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  State<PlannerPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<PlannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, ref, child) {
          final _user = ref.watch(userProvider);
          final _uid = _user.account!.uid;
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Planner')
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
                            ref.read(_calendarEventProvider);
                        _calendarProvider.addEvent(
                          CalendarEvent(
                            eventName:
                                '${_event['title'].toString().toUpperCase()},${_event['imageUrl']},$_done',
                            eventDate: DateTime.parse(_day),
                            eventID: _eventId,
                            eventTextColor: _eventTextColor,
                            eventBackgroundColor: _eventBackgroundColor,
                            // : _event['type'] == 'breakfast'
                            //     ? const Color(0xff81d4fA)
                            //     : _event['type'] == 'supper'
                            //         ? const Color(0xffffff00)
                            //         : Colors.indigo.shade900,
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
                            ref.watch(_calendarEventProvider);

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
                                            return _SelectedRecipeCard(
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
                            Consumer(
                              builder: (_, ref, child) {
                                final _calendar =
                                    ref.read(_calendarEventProvider);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RawMaterialButton(
                                      onPressed: () {
                                        // _calendar.changeView(
                                        //   viewType: 'Skipped',
                                        // );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            '${_calendar.eventsSkipped().length} ',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'skipped'.tr(),
                                          )
                                        ],
                                      ),
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        // _calendar.changeView(
                                        //   viewType: 'Done',
                                        // );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            '${_calendar.eventsDone().length} ',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Icon(
                                          //   _calendar.view == 'All' ||
                                          //           _calendar.view == 'Done'
                                          //       ? Icons.check_box
                                          //       : Icons.check_box_outline_blank,
                                          // ),
                                          Text('done'.tr())
                                        ],
                                      ),
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        // _calendar.changeView(
                                        //   viewType: 'Future',
                                        // );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            '${_calendar.futureEvents().length} ',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text('future'.tr())
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
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

class _SelectedRecipeCard extends StatefulWidget {
  final CalendarEvent event;

  const _SelectedRecipeCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<_SelectedRecipeCard> createState() => _SelectedRecipeCardState();
}

class _SelectedRecipeCardState extends State<_SelectedRecipeCard> {
  bool _showOptions = false;

  @override
  Widget build(BuildContext context) {
    final String _eventId = widget.event.eventID!;
    final DateTime _date = widget.event.eventDate;
    final String _title = widget.event.eventName.split(',')[0];
    final Color _color = widget.event.eventBackgroundColor;
    final String _imageUrl = widget.event.eventName.split(',')[1];
    final String _done = widget.event.eventName.split(',')[2];
    final bool _isToday = DateTime.now().compareTo(_date) == 0;
    String type() {
      String? _type = '';
      if (_color == const Color(0xff263238)) {
        _type = 'Dinner';
      } else if (_color == const Color(0xffffff00)) {
        _type = 'Supper';
      } else {
        _type = 'Breakfast';
      }
      return _type;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardColor,
            _color,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (_, ref, child) {
              final _router = ref.watch(routerProvider);
              return ListTile(
                onTap: () => _router.pushPage(
                  name: '/recipe',
                  arguments: {'id': _eventId},
                ),
                title: Text(_title),
                contentPadding: const EdgeInsets.all(1),
                minLeadingWidth: 50,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(_imageUrl),
                ),
                trailing: _done != 'true'
                    ? _isToday
                        ? IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  _showOptions = !_showOptions;
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: _showOptions ? 30 : 20,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit_off,
                              size: 25,
                            ),
                          )
                    : Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                      ),
                subtitle: Text(
                  type(),
                  style: TextStyle(
                    color: type() == 'Dinner' ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
          ),
          if (_showOptions)
            Consumer(
              builder: (_, ref, child) {
                final _user = ref.watch(userProvider);
                final _calendar = ref.watch(_calendarEventProvider);
                final _uid = _user.account!.uid;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RawMaterialButton(
                        fillColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          final String _dateString =
                              DateFormat('yyy-MM-dd HH:mm').format(_date);
                          FirebaseFirestore.instance
                              .collection('Planner')
                              .doc(_uid)
                              .update(
                            {
                              '$_eventId.days.$_dateString':
                                  FieldValue.delete(),
                            },
                          );
                          _calendar.removeEvent(widget.event);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                'delete'.tr(),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        fillColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          final String _dateString =
                              DateFormat('yyy-MM-dd HH:mm').format(_date);
                          FirebaseFirestore.instance
                              .collection('Planner')
                              .doc(_uid)
                              .update(
                            {
                              '$_eventId.days.$_dateString': true,
                            },
                          );
                          final CalendarEvent _newEvent = CalendarEvent(
                            eventName: '$_title,$_imageUrl,true',
                            eventDate: _date,
                            eventID: _eventId,
                            eventTextColor: _color,
                            eventBackgroundColor: Colors.green,
                          );
                          _calendar.updateEvent(widget.event, _newEvent);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                'done'.tr(),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class CalendarEventProvider extends ChangeNotifier {
  List<CalendarEvent> allEvents = [];
  List<String?> eventIds = [];
  Map<String, List> dailyEvents = {};
  DateTime? selectedDate;
  CalendarEvent? selectedEvent;
  Map<String, Widget>? recipesCard = {};

  void addEvent(CalendarEvent event) {
    if (!eventIds.contains('${event.eventID}-${event.eventDate}')) {
      eventIds.add('${event.eventID}-${event.eventDate}');
      allEvents.add(event);
    }
  }

  List<CalendarEvent> eventsSkipped() {
    return allEvents.where((event) {
      final String _doneStr = event.eventName.split(',')[2];
      final bool _done;
      if (_doneStr == 'true') {
        _done = true;
      } else {
        final bool _passed =
            !DateTime.now().compareTo(event.eventDate).isNegative;
        _done = !_passed && _doneStr == 'false';
      }

      return !_done;
    }).toList();
  }

  List<CalendarEvent> eventsDone() {
    return allEvents.where((event) {
      final String _doneStr = event.eventName.split(',')[2];
      final bool _done;
      if (_doneStr == 'true') {
        _done = true;
      } else {
        _done = false;
      }
      return _done;
    }).toList();
  }

  List<CalendarEvent> futureEvents() {
    return allEvents.where((event) {
      return DateTime.now().compareTo(event.eventDate).isNegative;
    }).toList();
  }

  void updateEvent(CalendarEvent oldEvent, CalendarEvent newEvent) {
    eventIds.remove(oldEvent.eventID);
    allEvents.remove(oldEvent);
    eventIds.add(newEvent.eventID);
    allEvents.add(newEvent);
    notifyListeners();
  }

  void removeEvent(CalendarEvent event) {
    eventIds.remove(event.eventID);
    allEvents.remove(event);
    notifyListeners();
  }

  void selectDay(CalendarEvent event, {DateTime? date}) {
    selectedEvent = event;
    selectedDate = date;
    notifyListeners();
  }
}
