import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/views/products/read/products_view.dart';
import '../../../../main.dart';

class ProductsStreamBuilder extends StatelessWidget {
  final String type;
  const ProductsStreamBuilder({@required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .doc(_user.account.uid)
            .snapshots(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
                alignment: Alignment.center,
                child: Text('oups, ${'somethingWentWrong'.tr()}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint(
                '--FIREBASE-- Reading: ProductsStream/${_user?.account?.uid} ');
            return const LoadingColumn();
          }
          if (snapshot.data != null) {
            final DocumentSnapshot<Map<String, dynamic>> _data =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>;
            return ProductsView(
              type: type,
              snapshot: _data,
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
