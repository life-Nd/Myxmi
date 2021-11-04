import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import '../main.dart';
import 'product_details.dart';
import 'product_fields.dart';

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
              return Consumer(
                builder: (_, watch, __) {
                  final _user = watch(userProvider);
                  return Dismissible(
                    key: UniqueKey(),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: widget.type == 'AddRecipe'
                              ? ProductField(product: widget.products[index])
                              : ProductDetails(product: widget.products[index]),
                        ),
                        if (!_user.onPhone)
                          _EditProductButton(
                            index: index,
                            color: Colors.red,
                            type: widget.type,
                            products: widget.products,
                          ),
                      ],
                    ),
                  );
                },
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
}

class _EditProductButton extends StatelessWidget {
  final int index;
  final Color color;
  final String type;
  final List<ProductModel> products;
  const _EditProductButton({
    Key key,
    @required this.index,
    @required this.color,
    @required this.type,
    @required this.products,
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
          onPressed: () {
            type == 'EditProducts'
                ? _delete(
                    uid: _user?.account?.uid,
                    productId: products[index].productId)
                : _hide(
                    productId: products[index].productId,
                    products: products,
                  );
          },
        );
      },
    );
  }

  Future _delete({@required String productId, @required String uid}) async {
    await FirebaseFirestore.instance.collection('Products').doc(uid).update(
      {
        productId: FieldValue.delete(),
      },
    );
  }

  void _hide(
      {@required List<ProductModel> products, @required String productId}) {
    products.removeWhere(
      (ProductModel element) => element.productId == productId,
    );
  }
}
