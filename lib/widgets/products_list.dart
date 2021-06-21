import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductsList extends StatefulWidget {
  final String uid;
  ProductsList({this.uid});
  createState() => ProductsListState();
}

class ProductsListState extends State<ProductsList> {
  static Stream _componentsStream;
  initState() {
    _componentsStream = FirebaseFirestore.instance
        .collection('Products')
        .doc('${widget.uid}')
        .snapshots();
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _componentsStream,
      builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('${'error'}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("WAITING PRODUCTSLISt");
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${'loading'.tr()}...'),
            ],
          );
        }
        if (snapshot.data.data() != null) {
          Map _data = snapshot.data.data();
          print("DATA:***** $_data");
          return Expanded(
            child: Consumer(builder: (context, watch, child) {
              return TextField(
                decoration: InputDecoration(hintText: 'Test'),
              );
            }),
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
