import 'package:flutter/material.dart';

class SelectableContainer extends StatelessWidget {
  final bool selected;
  final String text;
  const SelectableContainer({@required this.selected, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 4,
              color: selected
                  ? Theme.of(context).appBarTheme.titleTextStyle.color
                  : Colors.transparent),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: selected ? 17 : 19,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
