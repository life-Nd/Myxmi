import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/utils/loading_column.dart';
import '../../main.dart';
import 'add/add_product_view.dart';
import 'auto_complete_products.dart';
import 'products_list.dart';
import 'read/widgets/cart_button.dart';

TextEditingController _searchProductsCtrl = TextEditingController();

class Products extends StatefulWidget {
  final String type;
  const Products({@required this.type});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<ProductModel> _products(
      {DocumentSnapshot<Map<String, dynamic>> snapshot}) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .doc(_user.account.uid)
            .snapshots(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
                alignment: Alignment.center,
                child: Text('oups, ${'somethingWentWrong'.tr()}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint(
                '--FIREBASE-- Reading: Products/${_user?.account?.uid} ');
            return const LoadingColumn();
          }
          if (snapshot.data != null) {
            final DocumentSnapshot<Map<String, dynamic>> _data =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>;
            return ProductsView(
              type: widget.type,
              products: _products(snapshot: _data),
            );
          }
          return Center(
            child: Text(
              'productsEmpty'.tr(),
            ),
          );
        },
      );
    });
  }
}

class ProductsView extends StatelessWidget {
  final List<ProductModel> products;
  final String type;
  const ProductsView({
    Key key,
    @required this.products,
    @required this.type,
  }) : super(key: key);

  List<ProductModel> _filterProducts() {
    final List<ProductModel> _filteredProducts = [];
    final Iterable _filter = products.asMap().entries.where((entry) {
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 4, bottom: 8),
                    child: AutoCompleteProducts(
                        suggestions: products,
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
                    ? products
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
