import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/product.dart';
import '../add/add_new_product_view.dart';
import 'widgets/auto_complete_products.dart';
import 'widgets/cart_button.dart';
import 'widgets/products_list.dart';

TextEditingController _searchProductsCtrl = TextEditingController();

class ProductsView extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> snapshot;
  final String type;
  const ProductsView({
    Key key,
    @required this.snapshot,
    @required this.type,
  }) : super(key: key);
  List<ProductModel> _products() {
    if (snapshot.exists) {
      final Map _data = snapshot.data();
      final List _keys = snapshot.data().keys.toList();
      _keys.sort();
      final List _reversed = _keys.reversed.toList();
      return _reversed.map((key) {
        return ProductModel.fromSnapshot(
          keyIndex: key as String,
          snapshot: _data[key] as Map<String, dynamic>,
        );
      }).toList();
    } else {
      return [];
    }
  }

  List<ProductModel> _filterProducts() {
    final List<ProductModel> _filteredProducts = [];
    final Iterable _filter = _products().asMap().entries.where((entry) {
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
    debugPrint('building ProductsView');
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 4, bottom: 8),
                    child: AutoCompleteProducts(
                        suggestions: _products(),
                        controller: _searchProductsCtrl,
                        onSubmit: () {
                          // _filteredProducts.clear();
                          stateSetter(() {});
                        },
                        onClear: () {
                          _filterProducts().clear();
                          _searchProductsCtrl.clear();
                          stateSetter(() {});
                        }),
                  ),
                ),
                if (type == 'AddProcuctsToRecipe')
                  Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AddNewProduct(),
                          ),
                        );
                      },
                      tooltip: 'addProduct'.tr(),
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  )
                else
                  const CartButton()
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
              child: ProductsList(
                products: _searchProductsCtrl.text.isEmpty
                    ? _products()
                    : _filterProducts(),
                type: type,
              ),
            ),
          ],
        );
      },
    );
  }
}
