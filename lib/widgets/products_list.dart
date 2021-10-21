
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';

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
                          widget.products[index].productId: FieldValue.delete()
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
                    child: Row(
                      children: [
                        Expanded(
                          child: widget.type == 'AddRecipe'
                              ? ProductField(product: widget.products[index])
                              : ProductDetails(product: widget.products[index]),
                        ),
                        if (kIsWeb && !_user.onMobileApp)
                          IconButton(
                            icon: Icon(
                                widget.type == 'EditProducts'
                                    ? Icons.delete
                                    : Icons.visibility_off,
                                color: Colors.red),
                            onPressed: () {
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
                                    component:
                                        widget.products[index] as String);
                              }
                            },
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/data_not_found.png'),
              Text('productsEmpty'.tr()),
            ],
          );
  }
}
