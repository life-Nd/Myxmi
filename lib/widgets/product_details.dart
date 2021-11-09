import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

String _expiration;

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDetails({@required this.product});

  @override
  Widget build(BuildContext context) {
    final String _name =
        '${product.name[0]?.toUpperCase()}${product.name?.substring(1, product.name?.length)}';
    if (product?.expiration != null) {
      _expiration = DateFormat('EEEE d MMM , ' 'yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(
        int.parse(product?.expiration?.toString()),
      ));
    }
    if (product?.left == null) {
      product.left = '0';
    }

    return Consumer(builder: (_, watch, child) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          dense: true,
          title: Center(child: Text(_name)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(''),
              Text('${product.ingredientType.tr()} '),
              // Text('Quantity in stock: ${product.left} ${product.mesureType}'),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Colors.red,
                    onPressed: () async {
                      final SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      _prefs.setStringList(product.productId,
                          ['${int.parse(product.left) - 1}', _expiration]);
                    },
                    child: const Text(
                      '-',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Card(
                    child: Text(
                      '${product.left} ${product.mesureType}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Colors.green,
                    onPressed: () async {
                      final SharedPreferences _prefs =
                          await SharedPreferences.getInstance();
                      _prefs.setStringList(product.productId,
                          ['${int.parse(product.left) + 1}', _expiration]);
                    },
                    child: const Text(
                      '+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(''),
              Text('Expiry Date:  $_expiration'),
            ],
          ),
          trailing: EditCartButton(name: product.name),
        ),
      );
    });
  }
}

class EditCartButton extends StatelessWidget {
  const EditCartButton({Key key, this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) {
        final _prefs = watch(cartProvider);
        return IconButton(
          icon: _prefs?.cart != null && _prefs.cart.contains(name)
              ? const Icon(
                  Icons.shopping_cart,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.grey,
                ),
          onPressed: () async {
            debugPrint('name: $name');
            await _prefs.editCart(name: name);
          },
        );
      },
    );
  }
}
