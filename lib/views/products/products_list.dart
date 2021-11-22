import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'read/widgets/product_details.dart';
import 'read/widgets/product_fields.dart';

class ProductsList extends StatefulWidget {
  final List<ProductModel> products;
  final String type;
  const ProductsList({Key key, @required this.products, @required this.type})
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
                        Text(
                          widget.type == 'EditProducts'
                              ? 'delete'.tr()
                              : 'hide'.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        _EditProductButton(
                          index: index,
                          color: Colors.white,
                          type: widget.type,
                          products: widget.products,
                          setState: () => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: getProductDetails(
                            id: widget.products[index].productId),
                        builder: (_, AsyncSnapshot<ProductModel> snapshot) {
                          widget.products[index].left = snapshot?.data?.left;
                          widget.products[index].expiration =
                              snapshot?.data?.expiration;
                          return widget.type == 'AddProcuctsToRecipe'
                              ? ProductField(product: widget.products[index])
                              : ProductDetails(product: widget.products[index]);
                        },
                      ),
                    ),
                    if (!Device.get().isPhone)
                      _EditProductButton(
                        index: index,
                        color: Colors.red,
                        type: widget.type,
                        products: widget.products,
                        setState: () => setState(() {}),
                      ),
                  ],
                ),
              );
            },
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Image.asset('assets/data_not_found.png')),
              Expanded(child: Text('productsEmpty'.tr())),
            ],
          );
  }

  Future<ProductModel> getProductDetails({String id}) async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences _prefs = await prefs;
    final _stringList = _prefs.getStringList(id);
    final ProductModel _product = ProductModel();
    _product.left = _stringList[0];
    _product.expiration = _stringList[1];
    return _product;
  }
}

class _EditProductButton extends StatelessWidget {
  final int index;
  final Color color;
  final String type;
  final List<ProductModel> products;
  final Function setState;
  const _EditProductButton({
    Key key,
    @required this.index,
    @required this.color,
    @required this.type,
    @required this.products,
    @required this.setState,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, child) {
        final _user = watch(userProvider);
        return IconButton(
          padding: const EdgeInsets.all(1),
          icon: Icon(
            type == 'EditProducts' ? Icons.delete : Icons.visibility_off,
            color: color,
            size: 30,
          ),
          onPressed: () => editProducts(_user.account.uid),
        );
      },
    );
  }

  void editProducts(String uid) {
    if (type == 'EditProducts') {
      _delete(uid: uid, productId: products[index].productId);
    } else {
      _hide(
        productId: products[index].productId,
        products: products,
      );
    }

    setState();
  }

  Future _delete({@required String productId, @required String uid}) async {
    debugPrint('--FIREBASE-- Deleting: Products/$uid.$productId ');
    await FirebaseFirestore.instance.collection('Products').doc(uid).update(
      {
        productId: FieldValue.delete(),
      },
    );
  }

  void _hide(
      {@required List<ProductModel> products, @required String productId}) {
    debugPrint('--SHAREDPREFERENCES-- Deleting: $products $productId');
    products.removeWhere((ProductModel element) {
      debugPrint(
          'element.productId == productId: ${element.productId == productId}');
      return element.productId == productId;
    });
  }
}
