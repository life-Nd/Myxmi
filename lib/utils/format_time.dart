import 'package:intl/intl.dart';

String formatTime(DateTime time) {
  final String _time = DateFormat('EEE, MMM d, ' 'yy  h:mm a').format(time);
  return _time;
}

DateTime formatTimeFromMilliseconds(String time) {
  final DateTime _time = DateTime.fromMillisecondsSinceEpoch(
    int.parse(time),
  );
  return _time;
}
