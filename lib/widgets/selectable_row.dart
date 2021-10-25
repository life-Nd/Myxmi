import 'package:flutter/material.dart';
import 'selector_button.dart';

class SelectableRow extends StatelessWidget {
  final List<String> textList;
  final String type;
  const SelectableRow({Key key, @required this.textList, @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = ScrollController();
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      controller: _ctrl,
      children: textList
          .map((String item) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
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
