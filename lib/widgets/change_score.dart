import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

TextEditingController _scoreCtrl = TextEditingController();
Future<dynamic> changeScore({BuildContext context, String keyIndex}) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: TextField(
          maxLength: 3,
          controller: _scoreCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'New score',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        actions: [
          RawMaterialButton(
            fillColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('save'.tr()),
            onPressed: () {
              FirebaseFirestore.instance.collection('Vape').doc('Recipes').set({
                '$keyIndex': {'Score': '${_scoreCtrl.text}'}
              }, SetOptions(merge: true)).whenComplete(() {
                _scoreCtrl.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            },
          )
        ],
      );
    },
  );
}
