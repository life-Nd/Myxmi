import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/providers/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel? product;
  const ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _stockCtrl = TextEditingController();
    return Consumer(
      builder: (_, watch, child) {
        final String _name =
            '${product!.name![0].toUpperCase()}${product!.name?.substring(1, product!.name?.length)}';
        return Padding(
          padding:
              const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4, top: 4),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).cardColor,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // TODO : Add image to DB
                    SizedBox(
                      width: 77,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/rice.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${product!.ingredientType!.tr()} ',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    StatefulBuilder(
                      builder: (context, StateSetter setState) {
                        final String _productLeft = product?.left ?? '0';
                        return SizedBox(
                          width: 100,
                          height: 50,
                          child: TextField(
                            controller: _stockCtrl,
                            onEditingComplete: () {
                              debugPrint(
                                'product.left TAPPED ${product!.left}, ${_stockCtrl.text}',
                              );
                              product!.left = _stockCtrl.text;
                              setStock(
                                expiration: product!.expiration!,
                                id: product!.productId!,
                                quantity: double.parse(product!.left!),
                              );
                              _stockCtrl.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(
                                () {},
                              );
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              counterStyle: const TextStyle(fontSize: 27),
                              hintStyle: const TextStyle(fontSize: 22),
                              hintText: '$_productLeft ',
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      ' ${product?.mesureType} ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    EditCartButton(
                      name: '${product?.name}',
                    )
                  ],
                ),
                StatefulBuilder(
                  builder: (_, StateSetter stateSetter) {
                    DateTime _expiration;
                    String _expirationFormatted;
                    final String? _productLeft =
                        product?.left != null ? product!.left : '0';
                    if (product?.expiration != null) {
                      _expiration = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(product!.expiration!),
                      );
                    } else {
                      _expiration = DateTime.now();
                    }
                    _expirationFormatted =
                        DateFormat('EEEE d MMM , ' 'yyyy').format(_expiration);
                    return Row(
                      children: [
                        Text('${'expire'.tr()}:'),
                        IconButton(
                          onPressed: () {
                            product!.expiration =
                                '${_expiration.subtract(const Duration(days: 1)).millisecondsSinceEpoch}';
                            setExpiry(
                              id: product!.productId!,
                              quantity: int.parse(_productLeft!),
                              expiration: product!.expiration!,
                            );
                            stateSetter(
                              () {},
                            );
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
                                return child!;
                              },
                            );
                            if (_date != null && _date != _expiration) {
                              _expiration = _date;
                              product!.expiration =
                                  '${_date.millisecondsSinceEpoch}';
                              setExpiry(
                                id: product!.productId!,
                                quantity: int.parse(_productLeft!),
                                expiration: product!.expiration!,
                              );
                              stateSetter(
                                () {},
                              );
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
                            product!.expiration =
                                '${_expiration.add(const Duration(days: 1)).millisecondsSinceEpoch}';
                            setExpiry(
                              id: product!.productId!,
                              quantity: int.parse(_productLeft!),
                              expiration: product!.expiration!,
                            );
                            stateSetter(
                              () {},
                            );
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

  Future setStock({
    double? quantity,
    required String expiration,
    required String id,
  }) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList(
      id,
      ['$quantity', expiration],
    );
  }

  Future setExpiry({
    int? quantity,
    required String expiration,
    required String id,
  }) async {
    debugPrint('setExpiry: expiration: $expiration');
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList(
      id,
      ['$quantity', expiration],
    );
  }
}

class EditCartButton extends StatelessWidget {
  const EditCartButton({Key? key, required this.name}) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _prefs = ref.watch(cartProvider);
        return IconButton(
          icon: _prefs.cart.isNotEmpty && _prefs.cart.contains(name)
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
