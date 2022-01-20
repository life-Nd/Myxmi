import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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

  void updateDb({
    required String eventId,
    required String date,
    required String uid,
  }) {
    FirebaseFirestore.instance.collection('Calendar').doc(uid).update(
      {
        '$eventId.days.$date': true,
      },
    );
  }

  void updateEvent(
    CalendarEvent oldEvent,
    String uid,
    String title,
    String imageUrl,
  ) {
    eventIds.remove(oldEvent.eventID);
    allEvents.remove(oldEvent);
    final String _dateString =
        DateFormat('yyy-MM-dd HH:mm').format(oldEvent.eventDate);

    updateDb(eventId: oldEvent.eventID!, uid: uid, date: _dateString);
    final CalendarEvent newEvent = CalendarEvent(
      eventName: '$title,$imageUrl,true',
      eventDate: oldEvent.eventDate,
      eventID: oldEvent.eventID,
      eventTextColor: oldEvent.eventBackgroundColor,
      eventBackgroundColor: Colors.green,
    );
    eventIds.add(newEvent.eventID);
    allEvents.add(newEvent);
    notifyListeners();
  }

  void removeEvent(CalendarEvent event, String uid) {
    final String _dateString =
        DateFormat('yyy-MM-dd HH:mm').format(event.eventDate);
    FirebaseFirestore.instance.collection('Calendar').doc(uid).update(
      {
        '${event.eventID}.days.$_dateString': FieldValue.delete(),
      },
    );
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
