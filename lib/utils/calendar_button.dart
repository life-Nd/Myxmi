import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/utils/calendar_save_button.dart';

final TextEditingController _hourCtrl = TextEditingController();
final TextEditingController _minuteCtrl = TextEditingController();
String? _type;
String? _period;
Color? _selectedColor = Colors.grey;

class CalendarButton extends StatefulWidget {
  final RecipeModel? recipe;
  final Widget? childRecipe;
  const CalendarButton({
    Key? key,
    required this.recipe,
    @required this.childRecipe,
  }) : super(key: key);

  @override
  State<CalendarButton> createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  _CalendarButtonState({
    this.currentMonth,
    this.selectedDates,
    this.selectionMode = SelectionMode.single,
  }) {
    currentMonth ??= DateTime.now();
  }

  List<DateTime>? selectedDates;
  DateTime? currentMonth;
  SelectionMode selectionMode;
  GlobalKey<AwesomeCalendarState> calendarStateKey =
      GlobalKey<AwesomeCalendarState>();
  final DateTime firstDate = DateTime.now().subtract(const Duration(days: 1));
  final DateTime lastDate = DateTime.now().add(const Duration(days: 90));

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _router = ref.watch(routerProvider);
        return InkWell(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
          onTap: () async {
            final DateTime _now = DateTime.now();
            await showDateRangePicker(
              context: _,
              firstDate: _now,
              lastDate: _now.add(const Duration(days: 60)),
              builder: (BuildContext context, Widget? child) {
                return Container(
                  margin: const EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (_, StateSetter stateSetter) {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    widget.childRecipe!,
                                    Material(
                                      shape: const CircleBorder(),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: InkWell(
                                          child: const Icon(
                                            Icons.open_in_full_rounded,
                                            size: 24,
                                            color: Colors.black,
                                          ),
                                          onTap: () {
                                            _router.pushPage(
                                              name: '/planner',
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.recipe!.title!.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RawMaterialButton(
                                                  fillColor: _type ==
                                                          'breakfast'
                                                      ? Colors.amber.shade200
                                                      : Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    stateSetter(
                                                      () {
                                                        _type = 'breakfast';
                                                        _selectedColor = Colors
                                                            .amber.shade200;
                                                        _hourCtrl.text = '07';
                                                        _minuteCtrl.text = '00';
                                                        _period = 'am';
                                                      },
                                                    );
                                                  },
                                                  elevation: 20.0,
                                                  padding: const EdgeInsets.all(
                                                    15.0,
                                                  ),
                                                  child: Text(
                                                    'breakfast'.tr(),
                                                    style: TextStyle(
                                                      color: _type ==
                                                              'breakfast'
                                                          ? Colors.black
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .color,
                                                    ),
                                                  ),
                                                ),
                                                RawMaterialButton(
                                                  fillColor: _type == 'supper'
                                                      ? Colors.amber
                                                      : Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    stateSetter(
                                                      () {
                                                        _type = 'supper';
                                                        _selectedColor =
                                                            Colors.amber;
                                                        _hourCtrl.text = '1';
                                                        _minuteCtrl.text = '00';
                                                        _period = 'pm';
                                                      },
                                                    );
                                                    setState(() {});
                                                  },
                                                  elevation: 20.0,
                                                  padding: const EdgeInsets.all(
                                                    15.0,
                                                  ),
                                                  child: Text(
                                                    'supper'.tr(),
                                                    style: TextStyle(
                                                      color: _type == 'supper'
                                                          ? Colors.white
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .color,
                                                    ),
                                                  ),
                                                ),
                                                RawMaterialButton(
                                                  fillColor: _type == 'dinner'
                                                      ? Colors.indigo.shade900
                                                      : Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    stateSetter(
                                                      () {
                                                        _type = 'dinner';
                                                        _selectedColor = Colors
                                                            .indigo.shade900;
                                                        _hourCtrl.text = '07';
                                                        _minuteCtrl.text = '00';
                                                        _period = 'pm';
                                                      },
                                                    );
                                                  },
                                                  elevation: 20.0,
                                                  padding: const EdgeInsets.all(
                                                    15.0,
                                                  ),
                                                  child: Text(
                                                    'dinner'.tr(),
                                                    style: TextStyle(
                                                      color: _type == 'dinner'
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
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
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
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 40,
                                            ),
                                            SizedBox(
                                              width: 44,
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                controller: _hourCtrl,
                                                maxLength: 2,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(1),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                  hintText: '07',
                                                ),
                                              ),
                                            ),
                                            Text(
                                              ' : ',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 44,
                                              child: TextField(
                                                maxLength: 2,
                                                textAlign: TextAlign.center,
                                                controller: _minuteCtrl,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(1),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                  hintText: '00',
                                                  alignLabelWithHint: true,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 40,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 7,
                                              ),
                                              child: Column(
                                                children: [
                                                  RawMaterialButton(
                                                    fillColor: _period == 'am'
                                                        ? Colors.amber.shade200
                                                        : Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20.0,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      stateSetter(
                                                        () {
                                                          _period = 'am';
                                                        },
                                                      );
                                                    },
                                                    elevation: 20.0,
                                                    padding:
                                                        const EdgeInsets.all(
                                                      15.0,
                                                    ),
                                                    child: const Text(
                                                      'AM',
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RawMaterialButton(
                                                    fillColor: _period == 'pm'
                                                        ? _type == 'supper'
                                                            ? Colors.amber
                                                            : Colors
                                                                .indigo.shade900
                                                        : Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        20.0,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      stateSetter(
                                                        () {
                                                          _period = 'pm';
                                                        },
                                                      );
                                                    },
                                                    elevation: 20.0,
                                                    padding:
                                                        const EdgeInsets.all(
                                                      15.0,
                                                    ),
                                                    child: const Text(
                                                      'PM',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 5,
                                      top: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(
                                            Icons.keyboard_arrow_left,
                                          ),
                                          onPressed: () {
                                            stateSetter(
                                              () {
                                                calendarStateKey.currentState!
                                                    .setCurrentDate(
                                                  DateTime(
                                                    currentMonth!.year,
                                                    currentMonth!.month - 1,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Text(
                                          DateFormat('yMMMM')
                                              .format(currentMonth!)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.keyboard_arrow_right,
                                          ),
                                          onPressed: () {
                                            stateSetter(
                                              () {
                                                calendarStateKey.currentState!
                                                    .setCurrentDate(
                                                  DateTime(
                                                    currentMonth!.year,
                                                    currentMonth!.month + 1,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: double.infinity,
                                  child: Theme(
                                    data: ThemeData(
                                      colorScheme: Theme.of(context)
                                                  .brightness ==
                                              Brightness.light
                                          ? ColorScheme.highContrastLight(
                                              primary: Colors.green.shade500,
                                            )
                                          : const ColorScheme
                                              .highContrastDark(),
                                    ),
                                    child: AwesomeCalendar(
                                      key: calendarStateKey,
                                      startDate: _now,
                                      dayTileBuilder: CustomDayTileBuilder(),
                                      endDate:
                                          _now.add(const Duration(days: 90)),
                                      selectedSingleDate: DateTime.now(),
                                      selectedDates: selectedDates,
                                      selectionMode: selectionMode,
                                      onPageSelected:
                                          (DateTime? start, DateTime? end) {
                                        stateSetter(() {
                                          currentMonth = start;
                                          calendarStateKey.currentState!
                                              .setCurrentDate(
                                            DateTime(
                                              start!.year,
                                              start.month,
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Material(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          'selectRange'.tr(),
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        leading: Switch(
                                          activeColor: _selectedColor,
                                          value: selectionMode ==
                                              SelectionMode.range,
                                          onChanged: (bool value) {
                                            stateSetter(
                                              () {
                                                selectionMode = value
                                                    ? SelectionMode.range
                                                    : SelectionMode.multi;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            RawMaterialButton(
                                              fillColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              elevation: 20,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20,
                                                ),
                                              ),
                                              child: Text(
                                                'cancel'.tr(),
                                              ),
                                            ),
                                            const Spacer(),
                                            SaveButton(
                                              color: _selectedColor,
                                              selectedDates: calendarStateKey
                                                          .currentState !=
                                                      null
                                                  ? calendarStateKey
                                                      .currentState!
                                                      .selectedDates
                                                  : [],
                                              title: widget.recipe!.title,
                                              hour: _hourCtrl.text,
                                              minute: _minuteCtrl.text,
                                              recipeId: widget.recipe!.recipeId,
                                              imageUrl: widget.recipe!.imageUrl,
                                              type: _type,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
