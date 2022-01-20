import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/products/read/products_view.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/utils/no_data.dart';

class ProductsStreamBuilder extends StatelessWidget {
  final String type;
  const ProductsStreamBuilder({required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .doc(_user.account!.uid)
              .snapshots(),
          builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container(
                alignment: Alignment.center,
                child: Text('oups, ${'somethingWentWrong'.tr()}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              // TODO rebuilds from here when reloading the addInstructionsPage
              debugPrint(
                '--FIREBASE-- Reading: ProductsStream/${_user.account?.uid} ',
              );
              return const LoadingColumn();
            }
            if (snapshot.data != null && snapshot.data!.data() != null) {
              // final DocumentSnapshot _doc = snapshot.data.data();
              debugPrint('snapshot.data?.data(): ${snapshot.data?.data()}');
              final DocumentSnapshot<Map<String, dynamic>>? _data =
                  snapshot.data as DocumentSnapshot<Map<String, dynamic>>?;
              return ProductsView(
                type: type,
                snapshot: _data!,
              );
            }
            return const NoData(type: 'Product');
          },
        );
      },
    );
  }
}
