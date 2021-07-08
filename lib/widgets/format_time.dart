import 'package:intl/intl.dart';

String formatTime(String time) {
  final String _time = DateFormat('EEE, MMM d, ' 'yy  h:mm a').format(
    DateTime.fromMillisecondsSinceEpoch(
      int.parse(time),
    ),
  );
  return _time;
}
