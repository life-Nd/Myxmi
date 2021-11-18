import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/format_time.dart';

import '../add_product_view.dart';

class ExpiryDateSetter extends HookWidget {
  const ExpiryDateSetter({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _product = useProvider(productEntryProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_product.expiration != null)
            Text(
              formatTime(_product.expiration),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          else
            const Text(''),
          IconButton(
            onPressed: () async {
              final _date = await showDatePicker(
                  context: context,
                  currentDate: _product.expiration,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 5)),
                  lastDate: DateTime.now().add(
                    const Duration(days: 1200),
                  ),
                  builder: (_, child) {
                    return child;
                  });
              if (_date != null && _date != _product.expiration) {
                _product.changeExpiration(_date);
              }
            },
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () {
              _product.changeExpiration(null);
            },
            icon: Icon(
              Icons.clear,
              color: _product.expiration != null ? Colors.red : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
