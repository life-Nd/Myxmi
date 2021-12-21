import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/cart.dart';
import 'package:myxmi/providers/router.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _prefs = ref.watch(cartProvider);
        final _router = ref.watch(routerProvider);
        return FutureBuilder(
          future: _prefs.readCart(),
          builder: (context, snapshot) {
            return InkWell(
              onTap: () {
                _router.pushPage(name: '/cart');
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
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _prefs.cart.isNotEmpty
                              ? '${_prefs.cart.length}'
                              : '0',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
