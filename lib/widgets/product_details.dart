import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

final TextEditingController _stockCtrl = TextEditingController();

class ProductDetails extends StatelessWidget {
  final ProductModel product;
  const ProductDetails({@required this.product});

  @override
  Widget build(BuildContext context) {
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
                        fillColor: _productLeft != '0' ? Colors.red : null,
                        onPressed: () {
                          debugPrint('product.left TAPPED ${product.left}');
                          product.left = '${int.parse(_productLeft) - 1}';
                          changeStock(
                            expiration: product.expiration,
                            id: product.productId,
                            quantity: int.parse(_productLeft) - 1,
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
                      SizedBox(
                        width: 77,
                        // padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: TextField(
                            controller: _stockCtrl,
                            onEditingComplete: () {
                              debugPrint(
                                  'product.left TAPPED ${product.left}, ${_stockCtrl.text}');
                              product.left = _stockCtrl.text;
                              changeStock(
                                  expiration: product.expiration,
                                  id: product.productId,
                                  quantity: int.parse(_productLeft));
                              _stockCtrl.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                              stateSetter(() {});
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              counterStyle: const TextStyle(fontSize: 27),
                              hintStyle: const TextStyle(fontSize: 22),
                              hintText: '$_productLeft ${product?.mesureType}',
                            ),
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Colors.green,
                        onPressed: () async {
                          product.left = '${int.parse(_productLeft) + 1}';
                          changeStock(
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
                Text('${'expiryDate'.tr()} '),
                StatefulBuilder(
                  builder: (_, StateSetter stateSetter) {
                    DateTime _expiration;
                    String _expirationFormatted;
                    final String _productLeft =
                        product?.left != null ? product.left : '0';

                    if (product?.expiration != null) {
                      _expiration = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(product.expiration));
                    } else {
                      _expiration = DateTime.now();
                    }
                    _expirationFormatted =
                        DateFormat('EEEE d MMM , ' 'yyyy').format(_expiration);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            product.expiration =
                                '${_expiration.subtract(const Duration(days: 1)).millisecondsSinceEpoch}';
                            changeExpiry(
                              id: product.productId,
                              quantity: int.parse(_productLeft),
                              expiration: product.expiration,
                            );
                            stateSetter(() {});
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        InkWell(
                          onTap: () async {
                            final _date = await showDatePicker(
                                context: context,
                                currentDate: _expiration,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 5)),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 1200),
                                ),
                                builder: (_, child) {
                                  return child;
                                });
                            if (_date != null && _date != _expiration) {
                              _expiration = _date;
                              product.expiration =
                                  '${_date.millisecondsSinceEpoch}';
                              changeExpiry(
                                id: product.productId,
                                quantity: int.parse(_productLeft),
                                expiration: product.expiration,
                              );
                              stateSetter(() {});
                            }
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$_expirationFormatted ',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            product.expiration =
                                '${_expiration.add(const Duration(days: 1)).millisecondsSinceEpoch}';
                            changeExpiry(
                              id: product.productId,
                              quantity: int.parse(_productLeft),
                              expiration: product.expiration,
                            );
                            stateSetter(() {});
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future changeStock({int quantity, String expiration, String id}) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList(
      id,
      ['$quantity', expiration],
    );
  }

  Future changeExpiry({int quantity, String expiration, String id}) async {
    debugPrint('changeExpiry: expiration: $expiration');
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
