import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import '../main.dart';
import 'auto_complete_products.dart';
import 'product_details.dart';
import 'product_fields.dart';

TextEditingController _searchProductsCtrl = TextEditingController();

class ProductsList extends StatelessWidget {
  final String type;
  final double height;
  final EdgeInsetsGeometry padding;
  const ProductsList(
      {@required this.type, @required this.padding, @required this.height});

  @override
  Widget build(BuildContext context) {
    List<ProductModel> _products(
        {DocumentSnapshot<Map<String, dynamic>> snapshot}) {
      if (snapshot.exists) {
        return snapshot.data().keys.map((key) {
          return ProductModel.fromSnapshot(
            keyIndex: key,
            snapshot: snapshot.data()[key] as Map<String, dynamic>,
          );
        }).toList();
      } else {
        return [];
      }
    }

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
            return ProductsView(
              height: height,
              type: type,
              padding: padding,
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
  final double height;
  final EdgeInsetsGeometry padding;
  const ProductsView({
    Key key,
    @required this.products,
    @required this.type,
    @required this.padding,
    @required this.height,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ScrollController _controller = ScrollController();
  final List<ProductModel> _filteredProducts = [];
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
  void initState() {
    _searchProductsCtrl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              Padding(
                padding: widget.padding,
                child: Row(
                  children: [
                    Expanded(
                      child: AutoCompleteProducts(
                        suggestions: widget.products,
                        controller: _searchProductsCtrl,
                        onSubmit: () {
                          _filteredProducts.clear();
                          stateSetter(() {});
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _filteredProducts.clear();
                        _searchProductsCtrl.clear();
                        stateSetter(() {});
                      },
                    ),
                  ],
                ),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  _filteredProducts.clear();
                  _searchProductsCtrl.clear();
                  stateSetter(() {});
                },
                child: SizedBox(
                  height: widget.height,
                  child: _ProductsList(
                    products: _searchProductsCtrl.text.isEmpty
                        ? widget.products
                        : _filterProducts(),
                    type: widget.type,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductsList extends StatefulWidget {
  final List<ProductModel> products;
  final String type;
  const _ProductsList({Key key, @required this.products, @required this.type})
      : super(key: key);

  @override
  State<_ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<_ProductsList> {
  @override
  Widget build(BuildContext context) {
    return widget.products.isNotEmpty
        ? ListView.builder(
            itemCount: widget.products.length,
            itemBuilder: (_, index) {
              return Consumer(
                builder: (_, watch, __) {
                  final _recipe = watch(recipeProvider);
                  final _user = watch(userProvider);
                  return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        if (widget.type == 'EditProducts') {
                          FirebaseFirestore.instance
                              .collection('Products')
                              .doc(_user.account.uid)
                              .update({
                            widget.products[index].productId:
                                FieldValue.delete()
                          });
                        } else {
                          widget.products.remove(widget.products[index]);
                          _recipe.hide(
                              component: widget.products[index] as String);
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
                                widget.type == 'EditProducts'
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
                              Icon(widget.type == 'EditProducts'
                                  ? Icons.delete
                                  : Icons.visibility_off),
                            ],
                          ),
                        ),
                      ),
                      child: widget.type == 'AddRecipe'
                          ? ProductField(product: widget.products[index])
                          : ProductDetails(product: widget.products[index]));
                },
              );
            },
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/data_not_found.png'),
              Text('productsEmpty'.tr()),
            ],
          );
  }
}
