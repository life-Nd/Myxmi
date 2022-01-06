import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/calendar_entries.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    required this.selectedDates,
    required this.hour,
    required this.minute,
    required this.recipeId,
    required this.imageUrl,
    required this.type,
    required this.title,
    required this.color,
  }) : super(key: key);

  final List<DateTime>? selectedDates;
  final String? recipeId;
  final String? imageUrl;
  final String? title;
  final String? type;
  final String? hour;
  final String? minute;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _router = ref.watch(routerProvider);
        final _user = ref.watch(userProvider);
        final _calendar = ref.watch(calendarEntriesProvider);
        final _uid = _user.account!.uid;
        return RawMaterialButton(
          fillColor: type != null ? color : Colors.grey,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          onPressed: type != null
              ? () {
                  final String _now =
                      '${DateTime.now().millisecondsSinceEpoch}';
                  final Map _selectedDaysMapped = {};
                  if (selectedDates!.isNotEmpty) {
                    selectedDates!.sort();
                    for (int i = 0; i <= selectedDates!.length - 1; i++) {
                      final DateTime _date = selectedDates![i];
                      final String _dateString = DateFormat(
                        'yyy-MM-dd ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                      ).format(_date);

                      _selectedDaysMapped[_dateString] = false;
                    }
                    FirebaseFirestore.instance
                        .collection('Planner')
                        .doc(_uid)
                        .snapshots()
                        .listen(
                      (event) {
                        final Map _eventsData = event.data() ?? {};
                        if (_eventsData['$recipeId'] != null) {
                          final Map _recipe = _eventsData['$recipeId'] as Map;
                          final Map _days = _recipe['days'] as Map;
                          _selectedDaysMapped.addAll(_days);
                          FirebaseFirestore.instance
                              .collection('Planner')
                              .doc(_uid)
                              .update(
                            {
                              '$recipeId.days': _selectedDaysMapped,
                            },
                          );
                        } else {
                          FirebaseFirestore.instance
                              .collection('Planner')
                              .doc(_uid)
                              .set(
                            {
                              '$recipeId': {
                                'days': _selectedDaysMapped,
                                'created': _now,
                                'imageUrl': imageUrl,
                                'title': title,
                                'type': type,
                              }
                            },
                            SetOptions(merge: true),
                          );
                        }
                      },
                    );
                  }
                  _router.pushPage(
                    name: '/planner',
                  );
                }
              : () {
                  debugPrint(
                    'no type selected',
                  );
                },
          child: Text(
            'save'.tr(),
            style: TextStyle(
              color: _calendar.textColor,
            ),
          ),
        );
      },
    );
  }
}

class CustomDayTileBuilder extends DayTileBuilder {
  CustomDayTileBuilder();

  @override
  Widget build(
    BuildContext context,
    DateTime date,
    void Function(DateTime datetime)? onTap,
  ) {
    return Consumer(
      builder: (_, ref, child) {
        final _calendar = ref.watch(calendarEntriesProvider);
        return DefaultDayTile(
          date: date,
          onTap: onTap,
          selectedDayColor: _calendar.tileColor,
          currentDayBorderColor: _calendar.tileColor,
        );
      },
    );
  }
}
