import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/screens/cart_screen.dart';
import 'package:myxmi/widgets/products_list.dart';
import 'package:easy_localization/easy_localization.dart';

class Products extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('products'.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              Consumer(builder: (context, watch, child) {
                final _prefs = watch(prefProvider);
                return FutureBuilder(
                    future: _prefs.readCart(),
                    builder: (context, snapshot) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => CartScreen()),
                          );
                        },
                        child: Container(
                          width: 72,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 40,
                                  ),
                                  Text('', overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _prefs?.cart?.length != null
                                          ? '${_prefs.cart.length}'
                                          : '0',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }),
            ],
          ),
          const ProductsList(type: 'EditProducts'),
        ],
      ),
    );
  }
}
