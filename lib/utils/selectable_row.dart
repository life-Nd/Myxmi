import 'package:flutter/material.dart';
import 'selector_button.dart';

class SelectableRow extends StatelessWidget {
  final List<String> textList;
  final String type;
  const SelectableRow({Key key, @required this.textList, @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: textList
          .map((String item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SelectorButton(
                    value: item,
                    type: type,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
