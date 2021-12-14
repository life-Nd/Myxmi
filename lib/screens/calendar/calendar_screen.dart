import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cell_calendar/cell_calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/calendar.dart';
import 'package:myxmi/providers/user.dart';

DateTime? selectedDate;

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    final _calendar = ref.read(calendarEventsProvider);
    _calendar.yM = '${DateTime.now().year}-${DateTime.now().month}';
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: Scaffold(
        body: Consumer(
          builder: (_, ref, child) {
            final _user = ref.watch(userProvider);
            final _uid = _user.account!.uid;
            final _calendar = ref.watch(calendarEventsProvider);
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Calendar')
                        .doc('$_uid-${_calendar.yM}')
                        .snapshots(),
                    builder: (_, AsyncSnapshot snapshot) {
                      // final _data = snapshot?.data?.data();
                      return const MonthView();
                      // if (snapshot.connectionState ==
                      //     ConnectionState.waiting) {
                      //   return const LoadingColumn();
                      // }
                      // if (_data != null) {
                      //   for (final key in _data.keys) {
                      //     final _map = _data[key];
                      //     final _dates = _map['dates'].keys;
                      //     debugPrint('💎${_dates.length} 💎 ');

                      //     debugPrint('_dates:  $_dates');
                      //     for (final _date in _dates) {
                      //       _calendar.getEvents(
                      //           date: '$_date',
                      //           title: _map['title'] as String);
                      //     }
                      //     return CellCalendar(
                      //       monthYearLabelBuilder: (DateTime dateTime) {
                      //         _calendar.events = [];
                      //         return;
                      //       },
                      //       onPageChanged: (start, end) {
                      //         debugPrint('start: $start');
                      //         debugPrint('end: $end');

                      //         setState(() {
                      //           _calendar.changeYM(time: start);
                      //           selectedDate = null;
                      //         },);
                      //       },
                      //       events: _calendar.events,
                      //       onCellTapped: (date) {
                      //         debugPrint('date: $date');
                      //         setState(() {
                      //           selectedDate = date;
                      //         },);
                      //       },
                      //     );
                      //   }

                      //   return CellCalendar();
                      // } else {
                      //   return const LoadingColumn();
                      // }
                    },
                  ),
                ),
                if (selectedDate != null)
                  Card(
                    child: Column(
                      children: [
                        Text(
                          '${selectedDate!.day} ${selectedDate!.month} ${selectedDate!.year}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '',
                              // _calendar.events.toString(),
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
  }
}
