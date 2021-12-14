import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';

TextEditingController _searchProductsCtrl = TextEditingController();

class SearchProducts extends StatelessWidget {
  const SearchProducts({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _productsSearch = ref.watch(productsSearchProvider);
        return TextField(
          controller: _searchProductsCtrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            filled: true,
            hintText: 'searchInMyProducts'.tr(),
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () {
                _searchProductsCtrl.clear();
                _productsSearch.cancelSearch();
                if (!kIsWeb) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          onChanged: (value) => _productsSearch.searchTextChanged(value),
        );
      },
    );
  }
}

class SearchProductsProvider extends ChangeNotifier {
  bool isSearching = false;
  ProductModel? selectedProduct;
  late String searchText;
  List<ProductModel> _products = [];

  List<ProductModel?> products() {
    if (selectedProduct?.name == null) {
      return _products;
    } else {
      return [selectedProduct];
    }
  }

  List<ProductModel> allProducts(Map data) {
    final List _keys = data.keys.toList();
    _keys.sort();
    final List _reversed = _keys.reversed.toList();
    return _products = _reversed.map((key) {
      return ProductModel.fromSnapshot(
        keyIndex: key as String,
        snapshot: data[key] as Map<String, dynamic>,
      );
    }).toList();
  }

  List<ProductModel> suggestions() {
    return _products.where((product) {
      return searchText.isNotEmpty &&
          product.name!.contains(searchText.trim().toLowerCase());
    }).toList();
  }

  void search() {
    isSearching = true;
    _searchProductsCtrl.text = selectedProduct!.name!;
    notifyListeners();
  }

  void searchTextChanged(String ctrl) {
    searchText = ctrl;
    isSearching = true;
    notifyListeners();
  }

  void cancelSearch() {
    isSearching = false;
    selectedProduct = null;
    notifyListeners();
  }

  void selectProduct(ProductModel product) {
    selectedProduct = product;
    _searchProductsCtrl.text = selectedProduct!.name!;
    isSearching = false;
    notifyListeners();
  }
}

final productsSearchProvider = ChangeNotifierProvider<SearchProductsProvider>(
  (ref) => SearchProductsProvider(),
);
