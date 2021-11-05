import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/add_new_product.dart';

import 'auto_complete_products.dart';
import 'cart_button.dart';
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
    debugPrint('productview building');
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        debugPrint('productview StatefulBuilder building');
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
                if (widget.type == 'AddProcuctsToRecipe')
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
