import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import 'widgets/expiry_date_setter.dart';
import 'widgets/mesure_selector.dart';
import 'widgets/type_selector.dart';

final productEntryProvider = ChangeNotifierProvider<ProductEntryProvider>(
    (ref) => ProductEntryProvider());

final TextEditingController _nameCtrl = TextEditingController();
final TextEditingController _quantityCtrl = TextEditingController();

class AddNewProduct extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _product = useProvider(productEntryProvider);
    // final _change = useState<bool>(false);
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('newProduct'.tr()),
      ),
      bottomNavigationBar:
          _nameCtrl.text.isNotEmpty && _product.mesureType != null
              ? RawMaterialButton(
                  padding: const EdgeInsets.all(8),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.green,
                  onPressed:
                      _nameCtrl.text.isNotEmpty && _product.mesureType != null
                          ? () async {
                              await _product.saveToDb(uid: _user?.account?.uid);
                              Navigator.of(context).pop();
                            }
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'fieldsEmpty'.tr(),
                                  ),
                                ),
                              );
                            },
                  child: Text('save'.tr()),
                )
              : const Text(''),
      body: SizedBox(
        height: _size.height,
        child: SingleChildScrollView(
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
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  subtitle: _product.explainAccess
                      ? Text(
                          'youCanSaveProducts'.tr(),
                        )
                      : null,
                  trailing: IconButton(
                    icon: Icon(
                      _product.explainAccess ? Icons.close : Icons.help,
                      color: _product.explainAccess ? Colors.red : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      _product.changeExplainAccess();
                    },
                  )),
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
              const SizedBox(
                width: 4,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'productType'.tr(),
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              const ProductsTypeSelector(),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                dense: true,
                title: Text(
                  'mesuredIn'.tr(),
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              const MesureTypeSetter(),
              ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: SingleChildScrollView(
                  child: Text(
                    '${'quantityOnHand'.tr()} (${'optional'.tr()})',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    _product.explainQuantity ? Icons.close : Icons.help,
                    color: _product.explainQuantity ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    _product.changeExplainQuantity();
                  },
                ),
                subtitle: _product.explainQuantity
                    ? Text('enterTotalQuantity'.tr())
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 60),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantityCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: _product.mesureType,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'selectExpirationDate'.tr()} (${'optional'.tr()})',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    _product.explainExpiration ? Icons.close : Icons.help,
                    color:
                        _product.explainExpiration ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    _product.changeExplainExpiration();
                  },
                ),
                subtitle: _product.explainExpiration
                    ? Text('expirationDate'.tr())
                    : null,
              ),
              const ExpiryDateSetter(),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductEntryProvider extends ChangeNotifier {
  String type;
  DateTime expiration;
  int mesureValue = 0;
  String mesureType = 'g';
  bool explainAccess = false;
  bool explainQuantity = false;
  bool explainExpiration = false;
  void changeType(String newType) {
    type = newType;
    notifyListeners();
  }

  void changeExpiration(DateTime newExpiration) {
    expiration = newExpiration;
    notifyListeners();
  }

  void changeMesureValue(int newMesureValue) {
    mesureValue = newMesureValue;
    notifyListeners();
  }

  void changeMesureType(String newMesureType) {
    mesureType = newMesureType;
    notifyListeners();
  }

  void changeExplainAccess() {
    explainAccess = !explainAccess;
    notifyListeners();
  }

  void changeExplainQuantity() {
    explainQuantity = !explainQuantity;
    notifyListeners();
  }

  void changeExplainExpiration() {
    explainExpiration = !explainExpiration;
    notifyListeners();
  }

  Future saveToDb({@required String uid}) async {
    final String _now = '${DateTime.now().millisecondsSinceEpoch}';
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setStringList(_now, [
      _quantityCtrl.text.trim(),
      expiration.millisecondsSinceEpoch.toString()
    ]).then((bool success) {
      debugPrint('success: $success $_now');
      return _now;
    });
    debugPrint(
      '--SHAREDPREFERENCES-- Writing: $_now:[${_quantityCtrl.text.trim()},${expiration.millisecondsSinceEpoch.toString()}]',
    );
    await FirebaseFirestore.instance.collection('Products').doc(uid).set(
      {
        _now: {
          'name': _nameCtrl.text.toLowerCase().trim(),
          'mesureType': mesureType.trim(),
          'ingredientType': type.trim(),
        },
      },
      SetOptions(merge: true),
    );
    debugPrint('--FIREBASE-- Writing: Products/$uid/$_now');
    _nameCtrl.clear();
    _quantityCtrl.clear();
    reset();
  }

  void reset() {
    type = null;
    expiration = null;
    mesureValue = 0;
    mesureType = 'g';
    explainAccess = false;
    explainQuantity = false;
    explainExpiration = false;
    notifyListeners();
  }
}
