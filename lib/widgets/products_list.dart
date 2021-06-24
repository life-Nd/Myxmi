import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';

import 'fields.dart';

class ProductsList extends StatefulWidget {
  final String uid;
  ProductsList({this.uid});
  createState() => ProductsListState();
}

class ProductsListState extends State<ProductsList> {
  Future _componentsFuture;
  initState() {
    this._componentsFuture = FirebaseFirestore.instance
        .collection('Products')
        .doc('${widget.uid}')
        .get();
    super.initState();
  }

  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot>(
      future: _componentsFuture,
      builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${'error'}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("WAITING PRODUCTSLISt");
          return Container(
            alignment: Alignment.center,
            child: Text('${'loading'.tr()}...'),
          );
        }
        if (snapshot.data != null) {
          Map _data = snapshot.data.data();
          print("---DATA:---- $_data----");
          return Consumer(builder: (context, watch, child) {
            final _recipe = watch(recipeProvider);
            final _keys = _data.keys.toList();
            return Container(
              height: _size.height / 1.2,
              child: ListView.builder(
                  itemCount: _keys.length,
                  itemBuilder: (context, index) {
                    final _key = _keys[index];
                    print("KEY: $_key");
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        print('_key: $_key');
                        _data.remove(_data[index]);
                        _recipe.hide(component: _keys[index]);
                        print("REMOVED: ${_keys[index]}");
                        print("DISMISSED $direction");
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
                                'Delete',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Icon(Icons.delete),
                            ],
                          ),
                        ),
                      ),
                      child: Fields(
                        data: _data[_key],
                        recipe: _recipe,
                      ),
                    );
                  }),
            );
          });
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

class _Textfield extends StatefulWidget {
  createState() => _TextfieldState();
}

class _TextfieldState extends State<_Textfield> {
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(hintText: 'Test'),
    );
  }
}
