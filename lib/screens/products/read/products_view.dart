import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/screens/products/read/widgets/products_list.dart';
import 'package:myxmi/screens/products/read/widgets/search_products.dart';
import 'package:myxmi/screens/products/read/widgets/suggestions.dart';
import 'package:myxmi/utils/cart_button.dart';

class ProductsView extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> snapshot;
  final String type;
  const ProductsView({
    Key? key,
    required this.snapshot,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return Consumer(
          builder: (_, ref, child) {
            final _productsSearch = ref.watch(productsSearchProvider);
            final _router = ref.watch(routerProvider);
            final Map _data = snapshot.data()!;
            _productsSearch.allProducts(_data);
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 4,
                          bottom: _productsSearch.isSearching ? 1 : 8,
                        ),
                        child: const SearchProducts(),
                      ),
                    ),
                    if (type == 'AddProcuctsToRecipe')
                      Center(
                        child: IconButton(
                          onPressed: () {
                            _router.pushPage(name: '/add-product-manually');
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
                  child: Stack(
                    children: [
                      ProductsList(
                        products: _productsSearch.products(),
                        type: type,
                      ),
                      if (_productsSearch.isSearching)
                        const ProductsSuggestions(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
