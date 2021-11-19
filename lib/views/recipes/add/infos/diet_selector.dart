import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'selectable_row.dart';

class DietSelector extends StatelessWidget {
  const DietSelector({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _width = _size.width;
    return SizedBox(
      width: _width,
      height: _size.height * 0.3,
      child: const Center(
        child: SelectableRow(
          textList: [
            'vegan',
            'vegetarian',
            'keto',
            'other',
          ],
          type: 'diet',
        ),
      ),
    );
  }
}
