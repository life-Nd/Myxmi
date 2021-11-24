import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../add_new_product_view.dart';

class MesureTypeSetter extends HookWidget {
  const MesureTypeSetter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _change = useState<bool>(false);
    final _product = useProvider(productEntryProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.titleTextStyle.color,
          ),
          value: _product.mesureValue,
          dropdownColor: Theme.of(context).cardColor,
          onChanged: (val) {
            _product.mesureValue = val;
            _change.value = !_change.value;
          },
          items: [
            DropdownMenuItem(
              value: 0,
              onTap: () {
                _product.changeMesureType('g');
              },
              child: const Text(
                'g',
              ),
            ),
            DropdownMenuItem(
              value: 1,
              onTap: () {
                _product.changeMesureType('ml');
              },
              child: const Text(
                'ml',
              ),
            ),
            DropdownMenuItem(
              value: 2,
              onTap: () {
                _product.changeMesureType('drops');
              },
              child: Text(
                'drops'.tr(),
              ),
            ),
            DropdownMenuItem(
              value: 3,
              onTap: () {
                _product.changeMesureType('teaspoons');
              },
              child: Text(
                'teaspoons'.tr(),
              ),
            ),
            DropdownMenuItem(
              value: 4,
              onTap: () {
                _product.changeMesureType('tablespoons');
              },
              child: Text(
                'tablespoons'.tr(),
              ),
            ),
            DropdownMenuItem(
              value: 5,
              onTap: () {
                _product.changeMesureType('pieces');
              },
              child: Text(
                'pieces'.tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
