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
    if (product?.expiration != null) {
      _expiration = DateFormat('EEEE d MMM , ' 'yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(
        int.parse(product?.expiration?.toString()),
      ));
    }
    return Consumer(
      builder: (_, watch, child) {
        final String _name =
            '${product.name[0]?.toUpperCase()}${product.name?.substring(1, product.name?.length)}';
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    EditCartButton(name: product.name),
                  ],
                ),
                Text('${product.ingredientType.tr()} '),
                // Text('Quantity in stock: ${product.left} ${product.mesureType}'),

                StatefulBuilder(builder: (_, StateSetter stateSetter) {
                  final String _productLeft =
                      product?.left != null ? product.left : '0';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Colors.red,
                        onPressed: () async {
                          product.left = '${int.parse(product.left) - 1}';
                          changeProductDetails(
                            expiration: product.expiration,
                            id: product.productId,
                            quantity: int.parse(product.left) - 1,
                          );
                          stateSetter(() {});
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
                          '$_productLeft ${product?.mesureType}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Colors.green,
                        onPressed: () async {
                          product.left = '${int.parse(_productLeft) + 1}';
                          changeProductDetails(
                              expiration: product.expiration,
                              id: product.productId,
                              quantity: int.parse(_productLeft) + 1);
                          stateSetter(() {});
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
                  );
                }),
                const Text(''),
                Text('Expiry Date:  $_expiration'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future changeProductDetails(
      {int quantity, String expiration, String id}) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList(
      id,
      ['$quantity', expiration],
    );
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
