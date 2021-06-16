import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

TextEditingController _nameCtrl = TextEditingController();
String _newEntryValueType = 'Drops';

int _value = 0;

class AddComponent extends HookWidget {
  Widget build(BuildContext context) {
    final _change = useState<bool>(false);
    return Scaffold(
        appBar: AppBar(
          title: Text('addComponent'.tr()),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'enterIngredientName'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              DropdownButton(
                dropdownColor: Colors.grey.shade100,
                value: _value,
                onChanged: (val) {
                  _value = val;
                  _change.value = !_change.value;
                },
                items: [
                  DropdownMenuItem(
                    child: Text('g'),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text('ml'),
                    value: 1,
                    onTap: () {},
                  ),
                  DropdownMenuItem(
                    child: Text('Drops'),
                    value: 2,
                  ),
                ],
              )
              //     SingleChildScrollView(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         mainAxisSize: MainAxisSize.max,
              //         children: [
              //           SizedBox(
              //             width: 2,
              //           ),
              //           RawMaterialButton(
              //             fillColor: _newEntryValueType == 'g'
              //                 ? Colors.green
              //                 : Theme.of(context).cardColor,
              //             child: Text('g'),
              //             onPressed: () {
              //               _newEntryValueType = 'g';
              //               _change.value = !_change.value;
              //             },
              //           ),
              //           SizedBox(
              //             width: 4,
              //           ),
              //           RawMaterialButton(
              //             fillColor: _newEntryValueType == 'ml'
              //                 ? Colors.green
              //                 : Theme.of(context).cardColor,
              //             child: Text('ml'),
              //             onPressed: () {
              //               _newEntryValueType = 'ml';
              //               _change.value = !_change.value;
              //             },
              //           ),
              //           SizedBox(
              //             width: 4,
              //           ),
              //           RawMaterialButton(
              //             fillColor: _newEntryValueType == 'Drops'
              //                 ? Colors.green
              //                 : Theme.of(context).cardColor,
              //             child: Text('${'drops'.tr()}'),
              //             onPressed: () {
              //               _newEntryValueType = 'Drops';
              //               _change.value = !_change.value;
              //             },
              //           ),
              //           SizedBox(
              //             width: 2,
              //           ),
              //           RawMaterialButton(
              //             fillColor: _newEntryValueType == 'Teaspoons'
              //                 ? Colors.green
              //                 : Theme.of(context).cardColor,
              //             child: Text('teaSpoons'.tr()),
              //             onPressed: () {
              //               _newEntryValueType = 'Teaspoons';
              //               _change.value = !_change.value;
              //             },
              //           ),
              //           RawMaterialButton(
              //             fillColor: _newEntryValueType == 'Tablespoons'
              //                 ? Colors.green
              //                 : Theme.of(context).cardColor,
              //             child: Text('tableSpoons'.tr()),
              //             onPressed: () {
              //               _newEntryValueType = 'Tablespoons';
              //               _change.value = !_change.value;
              //             },
              //           ),
              //           RawMaterialButton(
              //             fillColor: _newEntryValueType == 'Pieces'
              //                 ? Colors.green
              //                 : Theme.of(context).cardColor,
              //             child: Text('pieces'.tr()),
              //             onPressed: () {
              //               _newEntryValueType = 'pieces';
              //               _change.value = !_change.value;
              //             },
              //           ),
              //         ],
              //       ),
              //     )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.green,
          child: Text('save'.tr()),
          onPressed: _nameCtrl.text.isNotEmpty && _newEntryValueType.isNotEmpty
              ? () {
                  FirebaseFirestore.instance
                      .collection('Vape')
                      .doc('Components')
                      .update({
                    '${_nameCtrl.text}': '$_newEntryValueType'
                  }).whenComplete(() {
                    _nameCtrl.clear();
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
        ));
  }
}
