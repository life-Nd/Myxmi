import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';

import '../main.dart';
import 'edit_products.dart';
import 'fields.dart';

class ProductsList extends StatelessWidget {
  final String type;

  const ProductsList({
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('building productsList');
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);
      return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Products')
            .doc(_user.account.uid)
            .get(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('loading future');
            return Container(
              alignment: Alignment.center,
              child: Text('${'loading'.tr()}...'),
            );
          }
          if (snapshot.data != null) {
            final Map _data = type == 'AddToCart'
                ? snapshot as Map
                : snapshot.data.data() as Map;
            return Consumer(
              builder: (_, watch, child) {
                final _recipe = watch(recipeProvider);
                final _keys = _data != null ? _data?.keys?.toList() : [];
                return SizedBox(
                  height: _size.height / 1.2,
                  child: _keys.isNotEmpty
                      ? ListView.builder(
                          itemCount: _keys.length,
                          itemBuilder: (context, index) {
                            final _key = _keys[index];
                            return Dismissible(
                                key: UniqueKey(),
                                onDismissed: (direction) {
                                  _data.remove(_data[index]);
                                  _recipe.hide(
                                      component: _keys[index] as String);
                                  if (type == 'EditProducts') {
                                    FirebaseFirestore.instance
                                        .collection('Products')
                                        .doc(_user.account.uid)
                                        .update({
                                      '${_keys[index]}': FieldValue.delete()
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
                                child: type == 'AddRecipe'
                                    ? Fields(
                                        data: _data[_key] as Map,
                                        recipe: _recipe,
                                      )
                                    : EditProducts(
                                        indexKey: _key as String,
                                        data: _data[_key] as Map));
                          },
                        )
                      : Center(
                          child: Text(
                            'productsEmpty'.tr(),
                          ),
                        ),
                );
              },
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
