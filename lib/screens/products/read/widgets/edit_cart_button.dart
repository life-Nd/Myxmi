import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/providers/user.dart';

class EditProductButton extends StatelessWidget {
  final int index;
  final Color color;
  final String type;
  final List<ProductModel?> products;
  final Function setState;
  const EditProductButton({
    Key? key,
    required this.index,
    required this.color,
    required this.type,
    required this.products,
    required this.setState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      if (Device.get().isPhone) {
        return Container();
      }
    } catch (error) {
      return Consumer(
        builder: (_, ref, child) {
          final _user = ref.watch(userProvider);
          return IconButton(
            padding: const EdgeInsets.all(1),
            icon: Icon(
              type == 'EditProducts' ? Icons.delete : Icons.visibility_off,
              color: color,
              size: 30,
            ),
            onPressed: () => editProducts(_user.account!.uid),
          );
        },
      );
    }
    return Container();
  }

  void editProducts(String uid) {
    if (type == 'EditProducts') {
      _delete(uid: uid, productId: products[index]!.productId!);
    } else {
      _hide(
        productId: products[index]!.productId,
        products: products,
      );
    }
  }

  Future _delete({required String productId, required String uid}) async {
    debugPrint('--FIREBASE-- Deleting: Products/$uid.$productId ');
    await FirebaseFirestore.instance.collection('Products').doc(uid).update(
      {
        productId: FieldValue.delete(),
      },
    );
  }

  void _hide({
    required List<ProductModel?> products,
    required String? productId,
  }) {
    debugPrint('--SHAREDPREFERENCES-- Deleting: $products $productId');
    products.removeWhere(
      (ProductModel? element) {
        debugPrint(
          'element.productId == productId: ${element!.productId == productId}',
        );
        return element.productId == productId;
      },
    );
  }
}
