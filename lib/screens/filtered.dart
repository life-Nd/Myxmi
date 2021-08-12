import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'recipes_stream.dart';

class Filtered extends StatefulWidget {
  final String legend;
  const Filtered(this.legend);
  @override
  State<StatefulWidget> createState() => _FilteredState();
}

class _FilteredState extends State<Filtered> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.legend.tr()}s'),
      ),
      body: RecipesStream(
        path: FirebaseFirestore.instance
            .collection('Recipes')
            .where('sub_category', isEqualTo: widget.legend)
            .snapshots(),
        height: 100.h,
        autoCompleteField: true,
      ),
    );
  }
}
