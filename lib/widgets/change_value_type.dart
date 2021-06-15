import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

TextEditingController _newEntryKey = TextEditingController();
String _newEntryValueType = 'Drops';

changeValueType({@required BuildContext context}) {
  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(builder: (context, StateSetter stateSetter) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: EdgeInsets.all(2),
          contentPadding: EdgeInsets.all(2),
          title: Text('addComponent'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _newEntryKey,
                  decoration: InputDecoration(
                    hintText: 'entryKey'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 2,
                    ),
                    RawMaterialButton(
                      fillColor: _newEntryValueType == 'g'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      child: Text("g"),
                      onPressed: () {
                        _newEntryValueType = 'g';
                        stateSetter(() {});
                      },
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    RawMaterialButton(
                      fillColor: _newEntryValueType == 'ml'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      child: Text("ml"),
                      onPressed: () {
                        _newEntryValueType = 'ml';
                        stateSetter(() {});
                      },
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    RawMaterialButton(
                      fillColor: _newEntryValueType == 'Drops'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      child: Text('${'drops'.tr()}'),
                      onPressed: () {
                        _newEntryValueType = 'Drops';
                        stateSetter(() {});
                      },
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    RawMaterialButton(
                      fillColor: _newEntryValueType == 'Teaspoons'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      child: Text('teaSpoons'.tr()),
                      onPressed: () {
                        _newEntryValueType = 'Teaspoons';
                        stateSetter(() {});
                      },
                    ),
                    RawMaterialButton(
                      fillColor: _newEntryValueType == 'Tablespoons'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      child: Text('tableSpoons'.tr()),
                      onPressed: () {
                        _newEntryValueType = 'Tablespoons';
                        stateSetter(() {});
                      },
                    ),
                    RawMaterialButton(
                      fillColor: _newEntryValueType == 'Pieces'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      child: Text('pieces'.tr()),
                      onPressed: () {
                        _newEntryValueType = 'pieces';
                        stateSetter(() {});
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              fillColor: Colors.green,
              child: Text('save'.tr()),
              onPressed:
                  _newEntryKey.text.isNotEmpty && _newEntryValueType.isNotEmpty
                      ? () {
                          FirebaseFirestore.instance
                              .collection('Vape')
                              .doc('Components')
                              .update({
                            '${_newEntryKey.text}': '$_newEntryValueType'
                          }).whenComplete(() {
                            _newEntryKey.clear();
                            _newEntryValueType = '';
                            Navigator.of(context).pop();
                          });
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('${'fieldsEmpty'.tr()}'),
                            ),
                          );
                        },
            )
          ],
        );
      });
    },
  );
}
