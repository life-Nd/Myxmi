import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/products/read/widgets/product_details.dart';
import 'package:myxmi/screens/products/read/widgets/product_fields.dart';
import 'package:myxmi/utils/edit_cart_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsList extends StatefulWidget {
  final List<ProductModel?> products;
  final String type;
  const ProductsList({Key? key, required this.products, required this.type})
      : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final ScrollController _ctrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return widget.products.isNotEmpty
        ? ListView.builder(
            controller: _ctrl,
            itemCount: widget.products.length,
            itemBuilder: (_, index) {
              return Dismissible(
                key: UniqueKey(),
                dismissThresholds: const {
                  DismissDirection.startToEnd: 0.4,
                },
                confirmDismiss: (direction) async {
                  return false;
                },
                movementDuration: const Duration(seconds: 7),
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
                        RawMaterialButton(
                          onPressed: () {
                            // editProducts(_user.account!.uid);
                            debugPrint('💎 DELETE');
                          },
                          child: Text(
                            widget.type == 'EditProducts'
                                ? 'delete'.tr()
                                : 'hide'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        EditProductButton(
                          index: index,
                          color: Colors.white,
                          type: widget.type,
                          products: widget.products,
                          setState: () => setState(() {
                            debugPrint('Delete tapped');
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                child: FutureBuilder(
                  future:
                      getProductDetails(id: widget.products[index]!.productId!),
                  builder: (_, AsyncSnapshot<ProductModel> snapshot) {
                    widget.products[index]!.left = snapshot.data?.left;
                    widget.products[index]!.expiration =
                        snapshot.data?.expiration;
                    return widget.type == 'AddProcuctsToRecipe'
                        ? ProductField(product: widget.products[index])
                        : ProductDetails(product: widget.products[index]);
                  },
                ),
              );
            },
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Image.asset('assets/data_not_found.png')),
                Expanded(child: Text('productsEmpty'.tr())),
              ],
            ),
          );
  }

  Future<ProductModel> getProductDetails({required String id}) async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences _prefs = await prefs;
    final _stringList = _prefs.getStringList(id)!;
    final ProductModel _product = ProductModel();
    _product.left = _stringList[0];
    _product.expiration = _stringList[1];
    return _product;
  }
}
