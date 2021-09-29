import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr()),
      ),
      body: Consumer(
        builder: (_, watch, child) {
          final _prefs = watch(cartProvider);
          if (_prefs.cart != null && _prefs.cart.isNotEmpty) {
            return ListView.builder(
              itemCount: _prefs.cart.length,
              itemBuilder: (_, int index) {
                return ListTile(
                  leading: IconButton(
                    icon: _prefs.checkedItem.contains(_prefs.cart[index])
                        ? const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          )
                        : const Icon(Icons.radio_button_unchecked),
                    onPressed: () async {
                      await _prefs.editItems(item: _prefs.cart[index]);
                    },
                  ),
                  title: Text(_prefs.cart[index].toUpperCase()),
                );
              },
            );
          }
          return Center(
            child: Text(
              'cartEmpty'.tr(),
            ),
          );
        },
      ),
    );
  }
}
