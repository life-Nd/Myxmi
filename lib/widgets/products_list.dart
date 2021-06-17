import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart';
import '../screens/add.dart';
import 'fields.dart';

class ProductsList extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _user = useProvider(userProvider);
    final Stream _componentsStream = FirebaseFirestore.instance
        .collection('Products')
        .doc('${_user.account.uid}')
        .snapshots();
    return Expanded(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _componentsStream,
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('${'error'}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${'loading'.tr()}...'),
              ],
            );
          }
          if (snapshot.data.data() != null) {
            Map _data = snapshot.data.data();
            print("DATA: $_data");
            return Fields(data: _data, recipe: _recipe);
          }
          return Center(
            child: Text(
              'productsEmpty'.tr(),
            ),
          );
        },
      ),
    );
  }
}
