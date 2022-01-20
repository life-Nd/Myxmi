import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/providers/calendar_entries.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/utils/calendar_recipe_metadata.dart';
import 'package:myxmi/utils/calendar_save_button.dart';

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
        final _calendar = ref.watch(calendarEntriesProvider);
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
                                              name: '/calendar',
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
                                CalendarRecipeMetaData(
                                  stateSetter: stateSetter,
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
                                  child: AwesomeCalendar(
                                    key: calendarStateKey,
                                    startDate: _now,
                                    dayTileBuilder: CustomDayTileBuilder(),
                                    endDate: _now.add(const Duration(days: 90)),
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
                                Material(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          'selectRange'.tr(),
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        leading: Switch(
                                          activeColor: _calendar.tileColor,
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
                                            SaveEventToCalendarButton(
                                              color: _calendar.tileColor,
                                              selectedDates: calendarStateKey
                                                          .currentState !=
                                                      null
                                                  ? calendarStateKey
                                                      .currentState!
                                                      .selectedDates
                                                  : [],
                                              title: widget.recipe!.title,
                                              hour: '${_calendar.time.hour}',
                                              minute:
                                                  '${_calendar.time.minute}',
                                              recipeId: widget.recipe!.recipeId,
                                              imageUrl: widget.recipe!.imageUrl,
                                              type: _calendar.type,
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
