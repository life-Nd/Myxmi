import 'package:flutter/material.dart';
import 'category_selector.dart';

class SelectableRow extends StatelessWidget {
  final List<String> textList;
  final String type;
  const SelectableRow({Key key, @required this.textList, @required this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: textList
          .map((String item) => Padding(
                padding: const EdgeInsets.all(8.0),
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
