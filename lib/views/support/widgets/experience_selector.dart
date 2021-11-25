import 'package:flutter/material.dart';

String _experience;

class ExperiencesSelector extends StatelessWidget {
  const ExperiencesSelector({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (_, StateSetter stateSetter) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            fillColor: _experience == 'bad' ? Colors.white : Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _experience = 'bad';
              stateSetter(() {});
            },
            child: const Text(
              '😡',
              style: TextStyle(fontSize: 30),
            ),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            fillColor:
                _experience == 'okay' ? Colors.white : Colors.transparent,
            onPressed: () {
              _experience = 'okay';
              stateSetter(() {});
            },
            child: const Text(
              '🙂',
              style: TextStyle(fontSize: 40),
            ),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            fillColor:
                _experience == 'amazing' ? Colors.white : Colors.transparent,
            onPressed: () {
              _experience = 'amazing';
              stateSetter(() {});
            },
            child: const Text(
              '😀',
              style: TextStyle(fontSize: 50),
            ),
          ),
        ],
      );
    });
  }
}
