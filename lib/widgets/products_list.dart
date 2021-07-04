import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';

import 'edit_products.dart';
import 'fields.dart';

class ProductsList extends StatefulWidget {
  final String uid;
  final String type;
  final Future componentsFuture;
  ProductsList(
      {@required this.uid,
      @required this.type,
      @required this.componentsFuture});
  createState() => ProductsListState();
}

class ProductsListState extends State<ProductsList> {
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: widget.componentsFuture,
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('${'error'}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: Text('${'loading'.tr()}...'),
          );
        }
        if (snapshot.data != null) {
          Map _data =
              widget.type == 'AddToCart' ? snapshot : snapshot.data.data();
          return Consumer(
            builder: (context, watch, child) {
              final _recipe = watch(recipeProvider);
              final _keys = _data.keys.toList();
              return Container(
                height: _size.height / 1.2,
                child: ListView.builder(
                  itemCount: _keys.length,
                  itemBuilder: (context, index) {
                    final _key = _keys[index];
                    return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          _data.remove(_data[index]);
                          _recipe.hide(component: _keys[index]);
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
                                  'delete'.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Icon(Icons.delete),
                              ],
                            ),
                          ),
                        ),
                        child: widget.type == 'AddRecipes'
                            ? Fields(
                                data: _data[_key],
                                recipe: _recipe,
                              )
                            : EditProducts(data: _data[_key], indexKey: _key));
                  },
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
  }
}
