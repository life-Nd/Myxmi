import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _plannerEventProvider = ChangeNotifierProvider<PlannerEventProvider>(
  (ref) => PlannerEventProvider(),
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
          final _calendarProvider = ref.watch(_plannerEventProvider);
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
                        _calendarProvider.addEvent(
                          CalendarEvent(
                            eventName:
                                '${_event['title'].toString().toUpperCase()},${_event['imageUrl']},$_done',
                            eventDate: DateTime.parse(_day),
                            eventID: _eventId,
                            eventTextColor: _event['type'] == 'dinner'
                                ? Colors.white
                                : Colors.black,
                            eventBackgroundColor: _event['type'] == 'breakfast'
                                ? const Color(0xff81d4fA)
                                : _event['type'] == 'supper'
                                    ? const Color(0xffffff00)
                                    : Colors.indigo.shade900,
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
                        final eventsOnTheDate =
                            _calendarProvider.events.where((element) {
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
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount: eventsOnTheDate.length,
                                  itemBuilder: (_, int index) {
                                    return _SelectedRecipeCard(
                                      eventId: eventsOnTheDate[index].eventID!,
                                      date: eventsOnTheDate[index].eventDate,
                                      title: eventsOnTheDate[index]
                                          .eventName
                                          .split(',')[0],
                                      color: eventsOnTheDate[index]
                                          .eventBackgroundColor,
                                      imageUrl: eventsOnTheDate[index]
                                          .eventName
                                          .split(',')[1],
                                      done: eventsOnTheDate[index]
                                          .eventName
                                          .split(',')[2],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
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
  final String eventId;
  final String title;
  final String imageUrl;
  final Color color;
  final String done;
  final DateTime date;
  const _SelectedRecipeCard({
    Key? key,
    required this.eventId,
    required this.title,
    required this.imageUrl,
    required this.color,
    required this.done,
    required this.date,
  }) : super(key: key);

  @override
  State<_SelectedRecipeCard> createState() => _SelectedRecipeCardState();
}

class _SelectedRecipeCardState extends State<_SelectedRecipeCard> {
  String type() {
    String? _type = '';
    if (widget.color == const Color(0xff263238)) {
      _type = 'Dinner';
    } else if (widget.color == const Color(0xffffff00)) {
      _type = 'Supper';
    } else {
      _type = 'Breakfast';
    }
    return _type;
  }

  bool _showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardColor,
            widget.color,
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
                  arguments: {'id': widget.eventId},
                ),
                title: Text(widget.title),
                contentPadding: const EdgeInsets.all(1),
                minLeadingWidth: 50,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(widget.imageUrl),
                ),
                trailing: widget.done != 'true'
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
                    : FutureBuilder(
                        future: SharedPreferences.getInstance().then(
                          (value) => value.getStringList(
                            'skippedRecipes',
                          ),
                        ),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            debugPrint('🔎 📱 loading skipped recipes');
                          }
                          if (snapshot.data != null) {
                            final List<String> _skippedRecipes =
                                snapshot.data! as List<String>;
                            if (_skippedRecipes.contains(widget.eventId)) {
                              return const Icon(
                                Icons.no_meals_ouline,
                                size: 24,
                                color: Colors.orange,
                              );
                            }
                          }
                          return const Icon(
                            Icons.check_circle_outline,
                            size: 24,
                            color: Colors.green,
                          );
                        },
                      ),
                subtitle: Text(
                  type(),
                  style: TextStyle(
                    color: type() == 'Dinner' ? Colors.white : Colors.black,
                  ),
                ),
                // trailing: IconButton(
                //   onPressed: () {
                //     setState(
                //       () {
                //         _showOptions = !_showOptions;
                //       },
                //     );
                //   },
                //   icon: Icon(
                //     Icons.edit,
                //     size: _showOptions ? 30 : 20,
                //   ),
                // ),
              );
            },
          ),
          if (_showOptions)
            Consumer(
              builder: (_, ref, child) {
                final _user = ref.watch(userProvider);
                final _router = ref.watch(routerProvider);
                final _uid = _user.account!.uid;
                final _month = '${widget.date.month}';
                final _year = '${widget.date.year}';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RawMaterialButton(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          debugPrint(
                            '${widget.eventId}.days.$_year-$_month.${widget.date}',
                          );
                          final String _dateString =
                              DateFormat('yyy-MM-dd hh:mm').format(widget.date);
                          FirebaseFirestore.instance
                              .collection('Planner')
                              .doc(_uid)
                              .update(
                            {
                              '${widget.eventId}.days.$_dateString':
                                  FieldValue.delete(),
                            },
                          );
                          _router.pushPage(name: '/home');
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
                      // RawMaterialButton(
                      //   fillColor:
                      //       Theme.of(context).scaffoldBackgroundColor,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   onPressed: () {
                      //     debugPrint(
                      //       '${widget.eventId}.days.$_year-$_month.${widget.date}',
                      //     );
                      //     final String _dateString =
                      //         DateFormat('yyy-MM-dd hh:mm')
                      //             .format(widget.date);
                      //     FirebaseFirestore.instance
                      //         .collection('Planner')
                      //         .doc(_uid)
                      //         .update(
                      //       {
                      //         '${widget.eventId}.days.$_dateString':
                      //             FieldValue.delete(),
                      //       },
                      //     );
                      //     setState(() {});
                      //     Navigator.of(context).pop();
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Row(
                      //       children: [
                      //         const Icon(
                      //           Icons.no_meals_ouline,
                      //           color: Colors.orange,
                      //         ),
                      //         const SizedBox(
                      //           width: 7,
                      //         ),
                      //         Text(
                      //           'skip'.tr(),
                      //           style: const TextStyle(
                      //             color: Colors.orange,
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      RawMaterialButton(
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          final String _dateString =
                              DateFormat('yyy-MM-dd hh:mm').format(widget.date);
                          FirebaseFirestore.instance
                              .collection('Planner')
                              .doc(_uid)
                              .update(
                            {
                              '${widget.eventId}.days.$_dateString': true,
                            },
                          );

                          _router.pushPage(name: '/home');
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

class PlannerEventProvider extends ChangeNotifier {
  List<CalendarEvent> events = [];
  List<String?> eventIds = [];
  Map<String, List> dailyEvents = {};
  DateTime? selectedDate;
  CalendarEvent? selectedEvent;
  Map<String, Widget>? recipesCard = {};

  void addEvent(CalendarEvent event) {
    if (!eventIds.contains('${event.eventID}-${event.eventDate}')) {
      eventIds.add('${event.eventID}-${event.eventDate}');
      events.add(event);
    }
  }

  void selectDay(CalendarEvent event, {DateTime? date}) {
    selectedEvent = event;
    selectedDate = date;
    notifyListeners();
  }
}
