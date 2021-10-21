import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/cart.dart';

import '../main.dart';
import 'auto_complete_products.dart';
import 'products_list.dart';

TextEditingController _searchProductsCtrl = TextEditingController();

class ProductsView extends StatefulWidget {
  final List<ProductModel> products;
  final String type;
  const ProductsView({
    Key key,
    @required this.products,
    @required this.type,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    _searchProductsCtrl = TextEditingController();
    super.initState();
  }

  List<ProductModel> _filterProducts() {
    final Iterable _filter = widget.products.asMap().entries.where((entry) {
      return entry.value.toMap().containsValue(
            _searchProductsCtrl.text.trim().toLowerCase(),
          );
    });
    final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
    _filtered.forEach((key, value) {
      _filteredProducts.add(value as ProductModel);
    });
    return _filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AutoCompleteProducts(
                      suggestions: widget.products,
                      controller: _searchProductsCtrl,
                      onSubmit: () {
                        _filteredProducts.clear();
                        stateSetter(() {});
                      },
                      onClear: () {
                        _filterProducts().clear();
                        _searchProductsCtrl.clear();
                        stateSetter(() {});
                      }),
                ),
                Column(
                  children: [
                    Consumer(builder: (context, watch, child) {
                      final _prefs = watch(cartProvider);
                      return FutureBuilder(
                          future: _prefs.readCart(),
                          builder: (context, snapshot) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => CartScreen()),
                                );
                              },
                              child: Container(
                                width: 72,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 40,
                                        ),
                                        Text('',
                                            overflow: TextOverflow.ellipsis),
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
                                            style: const TextStyle(
                                                color: Colors.white),
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
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: ProductsList(
                products: _searchProductsCtrl.text.isEmpty
                    ? widget.products
                    : _filterProducts(),
                type: widget.type,
              ),
            ),
          ],
        );
      },
    );
  }
}
