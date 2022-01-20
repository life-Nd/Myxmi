import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/calendar/calendar_screen.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _calendar = ref.read(calendarEventProvider);
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RawMaterialButton(
              onPressed: () {
                // _calendar.changeView(
                //   viewType: 'Skipped',
                // );
              },
              child: Row(
                children: [
                  Text(
                    '${_calendar.eventsSkipped().length} ',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'skipped'.tr(),
                  )
                ],
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                // _calendar.changeView(
                //   viewType: 'Done',
                // );
              },
              child: Row(
                children: [
                  Text(
                    '${_calendar.eventsDone().length} ',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Icon(
                  //   _calendar.view == 'All' ||
                  //           _calendar.view == 'Done'
                  //       ? Icons.check_box
                  //       : Icons.check_box_outline_blank,
                  // ),
                  Text('done'.tr())
                ],
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                // _calendar.changeView(
                //   viewType: 'Future',
                // );
              },
              child: Row(
                children: [
                  Text(
                    '${_calendar.futureEvents().length} ',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('future'.tr())
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
