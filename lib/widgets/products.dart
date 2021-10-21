import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import '../main.dart';
import 'products_view.dart';

class Products extends StatelessWidget {
  final String type;
  const Products({@required this.type});

  @override
  Widget build(BuildContext context) {
    List<ProductModel> _products(
        {DocumentSnapshot<Map<String, dynamic>> snapshot}) {
      if (snapshot.exists) {
        final Map _data = snapshot.data();
        final List _keys = snapshot.data().keys.toList();
        _keys.sort();
        final List _reversed = _keys.reversed.toList();
        return _reversed.map((key) {
          return ProductModel.fromSnapshot(
            keyIndex: key as String,
            snapshot: _data[key] as Map<String, dynamic>,
          );
        }).toList();
      } else {
        return [];
      }
    }

    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .doc(_user.account.uid)
            .snapshots(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('somethingWentWrong'.tr());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('-------loading future-------');
            return Container(
              alignment: Alignment.center,
              child: Text('${'loading'.tr()}...'),
            );
          }
          if (snapshot.data != null) {
            final DocumentSnapshot<Map<String, dynamic>> _data =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>;
            return ProductsView(
              type: type,
              products: _products(snapshot: _data),
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
