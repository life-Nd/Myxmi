import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cartProvider =
    ChangeNotifierProvider<CartProvider>((ref) => CartProvider());

class CartProvider extends ChangeNotifier {
  List<String> cart = [];
  List<String> checkedItem = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future editCart({required String? name}) async {
    final SharedPreferences prefs = await _prefs;
    // cart ??=[];
    if (cart.contains(name)) {
      cart.remove(name);
    } else {
      cart.add(name!);
    }
    debugPrint('name: $name');
    debugPrint('cart: $cart');
    prefs.setStringList('Cart', cart).then(
      (bool success) {
        return cart;
      },
    );
    notifyListeners();
  }

  Future editItems({required String? item}) async {
    final SharedPreferences prefs = await _prefs;
    checkedItem = [];
    checkedItem.contains(item)
        ? checkedItem.remove(item)
        : checkedItem.add(item!);
    prefs.setStringList('Items', checkedItem).then(
      (bool success) {
        return checkedItem;
      },
    );
    notifyListeners();
  }

  Future readCart() async {
    final SharedPreferences prefs = await _prefs;

    return cart = prefs.getStringList('Cart')!;
  }

  Future readItem() async {
    final SharedPreferences prefs = await _prefs;
    return cart = prefs.getStringList('Items')!;
  }
}
