import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';

TextEditingController _nameCtrl = TextEditingController();
TextEditingController _quantityCtrl = TextEditingController();
DateTime _expiration;
int _mesureValue = 0;
String _ingredientType = 'Other';
String _mesureType = 'g';
bool _explainAccess = false;
bool _explainQuantity = false;
bool _explainExpiration = false;

class NewProduct extends HookWidget {
  Widget build(BuildContext context) {
    final _change = useState<bool>(false);
    final _user = useProvider(userProvider);
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('newProduct'.tr()),
        actions: [
          RawMaterialButton(
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            fillColor: Colors.green,
            child: Text('save'.tr()),
            onPressed: _nameCtrl.text.isNotEmpty && _mesureType != null
                ? () async {
                    await FirebaseFirestore.instance
                        .collection('Products')
                        .doc('${_user.account.uid}')
                        .set(
                      {
                        '${DateTime.now().millisecondsSinceEpoch}': {
                          'Name': '${_nameCtrl.text}',
                          'MesureType': '$_mesureType',
                          'IngredientType': '$_ingredientType',
                          'Expiration': '$_expiration',
                          'Total': '${_quantityCtrl.text}'
                        },
                      },
                      SetOptions(merge: true),
                    ).whenComplete(() {
                      _nameCtrl.clear();
                      _mesureType = '';
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
      ),
      body: Container(
        height: _size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'enterProductName'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                subtitle: _explainAccess
                    ? Text(
                        'youCanSaveProducts'.tr(),
                      )
                    : null,
                trailing: _explainAccess
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          _explainAccess = false;
                          _change.value = !_change.value;
                        },
                      )
                    : IconButton(
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          _explainAccess = true;
                          _change.value = !_change.value;
                        },
                        icon: Icon(Icons.help),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'productName'.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              ListTile(
                dense: true,
                title: Text(
                  '${'productType'.tr()}',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Container(
                height: _size.height < 700 ? 240 : 300,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: GridView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(vertical: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 4,
                  ),
                  children: [
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: _ingredientType == 'Fruit'
                          ? Colors.orange.shade500
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        _ingredientType = 'Fruit';
                        _change.value = !_change.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset('assets/fruits.png'),
                            ),
                            Text(
                              'fruit'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: _ingredientType == 'Vegetable'
                          ? Colors.green.shade500
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        _ingredientType = 'Vegetable';
                        _change.value = !_change.value;
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset('assets/vegetables.png'),
                            ),
                            Text(
                              'vegetable'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: _ingredientType == 'Meat'
                          ? Colors.red.shade500
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        _ingredientType = 'Meat';
                        _change.value = !_change.value;
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset('assets/meat.png'),
                            ),
                            Text(
                              'meat'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: _ingredientType == 'SeaFood'
                          ? Colors.blue.shade100
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        _ingredientType = 'SeaFood';
                        _change.value = !_change.value;
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset('assets/seafood.png'),
                            ),
                            Text(
                              'seaFood'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: _ingredientType == 'Dairy&Eggs'
                          ? Colors.grey.shade300
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        _ingredientType = 'Dairy&Eggs';
                        _change.value = !_change.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset('assets/dairy.png'),
                            ),
                            Text(
                              'dairyEggs'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: _ingredientType == 'Oils'
                          ? Colors.grey.shade300
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        _ingredientType = 'Oils';
                        _change.value = !_change.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset('assets/eliquid.png'),
                            ),
                            Text(
                              'oils'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: _ingredientType == 'Other'
                          ? Colors.brown.shade200
                          : Theme.of(context).scaffoldBackgroundColor,
                      onPressed: () {
                        _ingredientType = 'Other';
                        _change.value = !_change.value;
                      },
                      child: Center(
                        child: Text(
                          'other'.tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                dense: true,
                title: Text(
                  '${'mesuredIn'.tr()}',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    dropdownColor: Colors.grey.shade100,
                    value: _mesureValue,
                    onChanged: (val) {
                      _mesureValue = val;
                      _change.value = !_change.value;
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          'g',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        value: 0,
                        onTap: () {
                          _mesureType = 'g';
                        },
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'ml',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        value: 1,
                        onTap: () {
                          _mesureType = 'ml';
                        },
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'drops'.tr(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        value: 2,
                        onTap: () {
                          _mesureType = 'drops';
                        },
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'teaspoons'.tr(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        value: 3,
                        onTap: () {
                          _mesureType = 'teaspoons';
                        },
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'tablespoons'.tr(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        value: 4,
                        onTap: () {
                          _mesureType = 'tablespoons';
                        },
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'pieces'.tr(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        value: 5,
                        onTap: () {
                          _mesureType = 'pieces';
                        },
                      ),
                    ],
                  ),
                ],
              ),
              ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  '${'quantityInHand'.tr()} ${'optional'.tr()}',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                trailing: _explainQuantity
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          _explainQuantity = false;
                          _change.value = !_change.value;
                        },
                      )
                    : IconButton(
                        iconSize: 30,
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          _explainQuantity = true;
                          _change.value = !_change.value;
                        },
                        icon: Icon(Icons.help),
                      ),
                subtitle:
                    _explainQuantity ? Text('enterTotalQuantity'.tr()) : null,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantityCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '$_mesureType',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Text(
                      '${'selectExpirationDate'.tr()} ',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                trailing: _explainExpiration
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          _explainExpiration = false;
                          _change.value = !_change.value;
                        },
                      )
                    : IconButton(
                        iconSize: 30,
                        alignment: Alignment.centerRight,
                        onPressed: () {
                          _explainExpiration = true;
                          _change.value = !_change.value;
                        },
                        icon: Icon(Icons.help),
                      ),
                subtitle:
                    _explainExpiration ? Text('expirationDate'.tr()) : null,
              ),
              RawMaterialButton(
                onPressed: () async {
                  var _date = await showDatePicker(
                      context: context,
                      currentDate: _expiration,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 5)),
                      lastDate: DateTime.now().add(
                        Duration(days: 1200),
                      ),
                      builder: (_, child) {
                        return child;
                      });
                  if (_date != null && _date != _expiration)
                    _expiration = _date;
                  _change.value = !_change.value;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _expiration != null
                        ? Text(
                            '${DateFormat.yMMMMEEEEd().format(_expiration)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(''),
                    Icon(
                      Icons.calendar_today_outlined,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
