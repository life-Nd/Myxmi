// import 'package:calendar_view/calendar_view.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:myxmi/providers/user.dart';

// final _calendarEventsProvider = ChangeNotifierProvider<CalendarEventsProvider>(
//   (_) => CalendarEventsProvider(),
// );

// class CalendarScreen extends StatelessWidget {
//   const CalendarScreen({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (_, ref, child) {
//         final _user = ref.watch(userProvider);
//         final _calendarProvider = ref.watch(_calendarEventsProvider);
//         final _uid = _user.account!.uid;
//         return StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('Planner')
//               .doc('$_uid-${_calendarProvider.yearMonth}')
//               .snapshots(),
//           builder: (
//             _,
//             AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
//           ) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               _calendarProvider.calendarController = EventController();
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (snapshot.data != null) {
//               debugPrint(
//                 'snapshot.data: ${snapshot.data!.data()}',
//               );
//               Map<String, dynamic>? _data = {};
//               _data = snapshot.data!.data();

//               final Map<String, dynamic>? _daysSelected =
//                   _data?['days'] as Map<String, dynamic>?;
//               _daysSelected!.forEach(
//                 (key, value) {
//                   final _date = DateTime(
//                     _calendarProvider.selectedDate!.year,
//                     _calendarProvider.selectedDate!.month,
//                     int.parse(key),
//                   );
//                   final _event = CalendarEventData(
//                     event: _data?['recipeId'],
//                     // start: _date,
//                     // end: _date,
//                     title: '${_data?['title']}',
//                     description: '${_data?['type']}',
//                     color: Colors.blue,
//                     date: _date,
//                   );
//                   if (!_calendarProvider.calendarController.events
//                       .contains(_event)) {
//                     debugPrint('adding event: $_event');
//                     // _events.add(_event);
//                     _calendarProvider.calendarController.add(_event);
//                   }
//                 },
//               );
//             }
//             return CalendarControllerProvider<Object?>(
//               controller: _calendarProvider.calendarController,
//               child: const Scaffold(
//                 body: _BodyCalendar(),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class _BodyCalendar extends StatelessWidget {
//   const _BodyCalendar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (_, ref, child) {
//         // final _user = ref.watch(userProvider);
//         // final _calendarProvider = ref.watch(_calendarEventsProvider);
//         // final _uid = _user.account!.uid;
//         // return Column(
//         //   children: [
//         //     Expanded(
//         // child: StreamBuilder(
//         //   stream: FirebaseFirestore.instance
//         //       .collection('Planner')
//         //       .doc('$_uid-${_calendarProvider.yearMonth}')
//         //       .snapshots(),
//         //   builder: (
//         //     _,
//         //     AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//         //         snapshot,
//         //   ) {
//         // if (snapshot.connectionState == ConnectionState.waiting) {
//         //   return const Center(
//         //     child: CircularProgressIndicator(),
//         //   );
//         // }
//         // if (snapshot.data == null) {}
//         // if (snapshot.data != null) {
//         //   debugPrint(
//         //     'snapshot.data: ${snapshot.data!.data()}',
//         //   );
//         //   Map<String, dynamic>? _data = {};
//         //   _data = snapshot.data!.data();

//         //   final Map<String, dynamic>? _daysSelected =
//         //       _data?['days'] as Map<String, dynamic>?;
//         //   _daysSelected!.forEach(
//         //     (key, value) {
//         //       final _date = DateTime(
//         //         _calendarProvider.selectedDate!.year,
//         //         _calendarProvider.selectedDate!.month,
//         //         int.parse(key),
//         //       );
//         //       final _event = CalendarEventData(
//         //         event: _data?['recipeId'],
//         //         // start: _date,
//         //         // end: _date,
//         //         title: '${_data?['title']}',
//         //         description: '${_data?['type']}',
//         //         color: Colors.blue,
//         //         date: _date,
//         //       );
//         //       if (!_calendarProvider.calendarController.events
//         //           .contains(_event)) {
//         //         debugPrint('adding event: $_event');
//         //         // _events.add(_event);
//         //         _calendarProvider.calendarController.add(_event);
//         //       }
//         //     },
//         //   );
//         // }
//         return const _MonthView();
//       },
//     );
//   }
// }

// class _MonthView extends StatelessWidget {
//   const _MonthView({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (_, ref, child) {
//         final _calendarProvider = ref.watch(_calendarEventsProvider);
//         return MonthView(
//           showBorder: false,
//           headerBuilder: (date) {
//             return ListTile(
//               leading: const Icon(Icons.search),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     DateFormat('MMMM yyyy')
//                         .format(_calendarProvider.visibleDate!)
//                         .toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           _calendarProvider.changeView('day');
//                         },
//                         icon: Icon(
//                           Icons.calendar_view_day,
//                           size: _calendarProvider.view == 'day' ? 25 : 20,
//                           color: _calendarProvider.view == 'day'
//                               ? Colors.green
//                               : Theme.of(context).textTheme.bodyText1!.color,
//                         ),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       _calendarProvider.changeView('week');
//                     },
//                     icon: Icon(
//                       Icons.calendar_view_week,
//                       size: _calendarProvider.view == 'week' ? 25 : 20,
//                       color: _calendarProvider.view == 'week'
//                           ? Colors.green
//                           : Theme.of(context).textTheme.bodyText1!.color,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       _calendarProvider.changeView('month');
//                     },
//                     icon: Icon(
//                       Icons.calendar_view_month,
//                       size: _calendarProvider.view == 'month' ? 25 : 20,
//                       color: _calendarProvider.view == 'month'
//                           ? Colors.green
//                           : Theme.of(context).textTheme.bodyText1!.color,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           // controller: _calendarProvider.calendarController,
//           onEventTap: (event, date) => debugPrint(event.toString()),
//           cellBuilder: (date, events, isToday, isInMonth) {
//             // debugPrint('CELLBUILDER: date $date');
//             // ignore: iterable_contains_unrelated_type
//             if (!_calendarProvider.dailyEvents.contains(
//               date,
//             )) {
//               _calendarProvider.dailyEvents =
//                   _calendarProvider.calendarController.getEventsOnDay(date);
//             }
//             return Column(
//               children: [
//                 Center(
//                   child: Text(
//                     '${date.day}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: _calendarProvider.dailyEvents.length,
//                     itemBuilder: (_, int index) {
//                       debugPrint(
//                         '_calendarProvider.dailyEvents: ${_calendarProvider.dailyEvents}',
//                       );
//                       return Card(
//                         color: Colors.blue.shade400,
//                         child: Text(
//                           '${_calendarProvider.dailyEvents[index]!.title} ',
//                           style: const TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//           onPageChange: (DateTime time, index) {
//             // _calendarProvider.changeMonth(time);
//           },
//           onCellTap: (List events, DateTime date) {
//             // _calendarProvider.changeSelectedDate(date);
//           },
//         );
//       },
//     );
//   }
// }

// class CalendarEventsProvider extends ChangeNotifier {
//   String view = 'month';
//   DateTime? visibleDate = DateTime.now();
//   String yearMonth = '${DateTime.now().year}-${DateTime.now().month}';
//   DateTime? selectedDate = DateTime.now();

//   EventController calendarController = EventController();
//   List<CalendarEventData?> dailyEvents = [];

//   void changeSelectedDate(DateTime date) {
//     selectedDate = date;
//     notifyListeners();
//   }

//   void changeView(String _view) {
//     view = _view;
//     notifyListeners();
//   }

//   void changeMonth(DateTime? date) {
//     // calendarController = EventController();
//     dailyEvents = [];
//     visibleDate = date;
//     yearMonth = '${date!.year}-${date.month}';
//     debugPrint('changeMonth  yearMonth: $yearMonth');
//     notifyListeners();
//   }

// /* if (_calendarProvider.selectedDate != null)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         '${DateFormat('dd MMMM, ' 'yyyy').format(_calendarProvider.selectedDate!).toUpperCase()} ',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             _calendarProvider.yearMonth,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(10),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           gradient: LinearGradient(
//                             colors: [
//                               Theme.of(context).scaffoldBackgroundColor,
//                               Theme.of(context).cardColor,
//                             ],
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListTile(
//                               leading: SizedBox(
//                                 width: 77,
//                                 child: ClipRRect(
//                                   borderRadius:
//                                       BorderRadius.circular(20),
//                                   child: Image.asset(
//                                     'assets/rice.jpg',
//                                   ),
//                                 ),
//                               ),
//                               title: const Text('Eggs'),
//                               subtitle: const Text('1 dozen'),
//                               trailing: const Icon(Icons.edit),
//                             ),
//                           ],
//                         ),
//                       ),
//             ],
//             ),
//             ),
//             ),
//             */
// }
