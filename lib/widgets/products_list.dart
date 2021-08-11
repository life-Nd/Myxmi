import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import 'auto_complete_products.dart';
import 'edit_products.dart';
import 'fields.dart';

TextEditingController _searchProductsCtrl = TextEditingController();

class ProductsList extends StatelessWidget {
  final String type;
  const ProductsList({
    @required this.type,
  });

  // final List<ProductModel> _products = [];
  @override
  Widget build(BuildContext context) {
    List<ProductModel> _products(
        {DocumentSnapshot<Map<String, dynamic>> snapshot}) {
      debugPrint('snapshot: ${snapshot.data()}');
      return snapshot.data().keys.map((key) {
        debugPrint('key: $key');
        debugPrint('snapshot.data(): ${snapshot.data()}');
        return ProductModel.fromSnapshot(
          keyIndex: key,
          snapshot: snapshot.data()[key] as Map<String, dynamic>,
        );
      }).toList();
    }

    debugPrint('building productsList');
    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .doc(_user.account.uid)
            .snapshots(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('-------loading future-------');
            return Container(
              alignment: Alignment.center,
              child: Text('${'loading'.tr()}...'),
            );
          }
          if (snapshot.data != null) {
            debugPrint('snapshot.data: ${snapshot.data.data()}');
            return ProductsView(
              type: type,
              products: _products(
                  snapshot:
                      snapshot.data as DocumentSnapshot<Map<String, dynamic>>),
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
  List<ProductModel> _filterProducts() {
    final Iterable _filter = widget.products.asMap().entries.where((entry) {
      return entry.value.toMap().containsValue(
            _searchProductsCtrl.text.trim().toLowerCase(),
          );
    });
    final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
    _filtered.forEach((key, value) {
      debugPrint('value: ${value.name}');
      _filteredProducts.add(value as ProductModel);
    });
    return _filteredProducts;
  }

  @override
  void initState() {
    _searchProductsCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
                child: AutoCompleteProducts(
                  suggestions: widget.products,
                  controller: _searchProductsCtrl,
                  onSubmit: () {
                    _filteredProducts.clear();
                    stateSetter(() {});
                  },
                ),
              ),
              SizedBox(
                height: 90.h,
                child: _ProductsList(
                  products: _searchProductsCtrl.text.isEmpty
                      ? widget.products
                      : _filterProducts(),
                  type: widget.type,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductsList extends StatelessWidget {
  final List<ProductModel> products;
  final String type;
  const _ProductsList({Key key, @required this.products, @required this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty
        ? ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final ProductModel _product = products[index];
              debugPrint('product: ${products[index].name}');
              debugPrint('key:${_product.expiration}');
              return Consumer(
                builder: (_, watch, __) {
                  final _recipe = watch(recipeProvider);
                  final _user = watch(userProvider);
                  return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        products.remove(products[index]);
                        _recipe.hide(component: products[index] as String);
                        if (type == 'EditProducts') {
                          FirebaseFirestore.instance
                              .collection('Products')
                              .doc(_user.account.uid)
                              .update({
                            products[index].productId: FieldValue.delete()
                          });
                        }
                      },
                      background: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                type == 'EditProducts'
                                    ? 'delete'.tr()
                                    : 'hide'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              Icon(type == 'EditProducts'
                                  ? Icons.delete
                                  : Icons.visibility_off),
                            ],
                          ),
                        ),
                      ),
                      // TODO fix what shows when you filter the products
                      child: type == 'AddRecipe'
                          ? Fields(
                              product: products[index],
                              recipe: _recipe,
                            )
                          : EditProducts(product: products[index]));
                },
              );
            },
          )
        : Center(
            child: Text(
              'productsEmpty'.tr(),
            ),
          );
  }
}
