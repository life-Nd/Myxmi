import 'package:cell_calendar/cell_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/calendar/calendar_screen.dart';

class SelectedRecipeCard extends StatefulWidget {
  final CalendarEvent event;

  const SelectedRecipeCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<SelectedRecipeCard> createState() => SelectedRecipeCardState();
}

class SelectedRecipeCardState extends State<SelectedRecipeCard> {
  bool _showOptions = false;

  @override
  Widget build(BuildContext context) {
    final String _eventId = widget.event.eventID!;
    final DateTime _date = widget.event.eventDate;
    final String _title = widget.event.eventName.split(',')[0];
    final Color _color = widget.event.eventBackgroundColor;
    final String _imageUrl = widget.event.eventName.split(',')[1];
    final String _done = widget.event.eventName.split(',')[2];
    final DateTime _now = DateTime.now();
    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
    final String _nowDateStr = _dateFormat.format(_now);
    final String _eventDateStr = _dateFormat.format(_date);
    final DateTime _nowDate = DateTime.parse(_nowDateStr);
    final DateTime _eventDate = DateTime.parse(_eventDateStr);
    final int _dateDifference = _nowDate.difference(_eventDate).inDays;
    final bool _isToday = _dateDifference >= -1 && _dateDifference <= 1;
    String type() {
      String? _type = '';
      if (_color == const Color(0xff263238)) {
        _type = 'Dinner';
      } else if (_color == const Color(0xffffff00)) {
        _type = 'Supper';
      } else {
        _type = 'Breakfast';
      }
      return _type;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardColor,
            _color,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (_, ref, child) {
              final _router = ref.watch(routerProvider);
              return ListTile(
                onTap: () => _router.pushPage(
                  name: '/recipe',
                  arguments: {'id': _eventId},
                ),
                title: Text(_title),
                contentPadding: const EdgeInsets.all(1),
                minLeadingWidth: 50,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(_imageUrl),
                ),
                trailing: _done != 'true'
                    ? _isToday
                        ? IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  _showOptions = !_showOptions;
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: _showOptions ? 30 : 20,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit_off,
                              size: 25,
                            ),
                          )
                    : Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                      ),
                subtitle: Text(
                  type(),
                  style: TextStyle(
                    color: type() == 'Dinner' ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
          ),
          if (_showOptions)
            Consumer(
              builder: (_, ref, child) {
                final _user = ref.read(userProvider);
                final _calendar = ref.read(calendarEventProvider);
                final _uid = _user.account!.uid;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RawMaterialButton(
                        fillColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          _calendar.removeEvent(widget.event, _uid);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                'delete'.tr(),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        fillColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          _calendar.updateEvent(
                            widget.event,
                            _uid,
                            _title,
                            _imageUrl,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                'done'.tr(),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
