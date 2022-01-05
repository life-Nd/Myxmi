import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/calendar_save_button.dart';

class CalendarRecipeTypeSelector extends StatefulWidget {
  const CalendarRecipeTypeSelector({
    Key? key,
    required this.stateSetter,
  }) : super(key: key);
  final StateSetter stateSetter;

  @override
  State<CalendarRecipeTypeSelector> createState() =>
      _CalendarRecipeTypeSelectorState();
}

class _CalendarRecipeTypeSelectorState
    extends State<CalendarRecipeTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _calendar = ref.watch(calendarEntriesProvider);
        return Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 5,
            bottom: 5,
          ),
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${'chooseRecipeType'.tr()} ',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RawMaterialButton(
                          fillColor: _calendar.type == 'breakfast'
                              ? Colors.amber.shade200
                              : Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          onPressed: () {
                            widget.stateSetter(
                              () {
                                _calendar.type = 'breakfast';
                                _calendar.time =
                                    const TimeOfDay(hour: 8, minute: 00);
                              },
                            );
                            _calendar.changeColor(
                              Colors.amber.shade200,
                              Colors.black,
                            );
                            _calendar.showTimeSelector = false;
                          },
                          elevation: 20.0,
                          padding: const EdgeInsets.all(
                            15.0,
                          ),
                          child: Text(
                            'breakfast'.tr(),
                            style: TextStyle(
                              color: _calendar.type == 'breakfast'
                                  ? Colors.black
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                            ),
                          ),
                        ),
                        RawMaterialButton(
                          fillColor: _calendar.type == 'supper'
                              ? Colors.amber
                              : Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          onPressed: () {
                            widget.stateSetter(
                              () {
                                _calendar.type = 'supper';
                                _calendar.time =
                                    const TimeOfDay(hour: 14, minute: 00);
                                _calendar.showTimeSelector = false;
                              },
                            );

                            _calendar.changeColor(
                              Colors.amber,
                              Colors.white,
                            );
                          },
                          elevation: 20.0,
                          padding: const EdgeInsets.all(
                            15.0,
                          ),
                          child: Text(
                            'supper'.tr(),
                            style: TextStyle(
                              color: _calendar.type == 'supper'
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                            ),
                          ),
                        ),
                        RawMaterialButton(
                          fillColor: _calendar.type == 'dinner'
                              ? Colors.indigo.shade900
                              : Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          onPressed: () {
                            widget.stateSetter(
                              () {
                                _calendar.type = 'dinner';
                                _calendar.time = const TimeOfDay(
                                  hour: 19,
                                  minute: 00,
                                );
                              },
                            );

                            _calendar.changeColor(
                              Colors.indigo.shade900,
                              Colors.white,
                            );
                            _calendar.showTimeSelector = false;
                          },
                          elevation: 20.0,
                          padding: const EdgeInsets.all(
                            15.0,
                          ),
                          child: Text(
                            'dinner'.tr(),
                            style: TextStyle(
                              color: _calendar.type == 'dinner'
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_calendar.showTimeSelector)
                  const TimeSelector()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        onPressed: () {
                          setState(() {
                            _calendar.showTimeSelector = true;
                          });
                        },
                        child: Text('${_calendar.time.format(context)} '),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimeSelector extends StatefulWidget {
  const TimeSelector({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _calendar = ref.watch(calendarEntriesProvider);
        return Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 5,
            bottom: 5,
          ),
          child: Card(
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20.0,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${'chooseTime'.tr()} ',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: _calendar.date,
                          onDateTimeChanged: (DateTime newDateTime) {
                            final _newTime = TimeOfDay.fromDateTime(
                              newDateTime,
                            );
                            _calendar.time = _newTime;
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _calendar.showTimeSelectorChanged();
                        },
                        icon: const Icon(
                          Icons.save_alt,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
