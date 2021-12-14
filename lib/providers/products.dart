import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductEntryProvider extends ChangeNotifier {
  String? type;
  DateTime? expiration;
  int? mesureValue = 0;
  String mesureType = 'g';
  bool explainAccess = false;
  bool explainQuantity = false;
  bool explainExpiration = false;
  void changeType(String newType) {
    type = newType;
    notifyListeners();
  }

  void changeExpiration(DateTime? newExpiration) {
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

  Future saveToDb({
    required String? uid,
    required String quantity,
    required String name,
  }) async {
    final String _now = '${DateTime.now().millisecondsSinceEpoch}';
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setStringList(
      _now,
      [quantity.trim(), expiration!.millisecondsSinceEpoch.toString()],
    ).then(
      (bool success) {
        debugPrint('success: $success $_now');
        return _now;
      },
    );
    debugPrint(
      '--SHAREDPREFERENCES-- Writing: $_now:[${quantity.trim()},${expiration!.millisecondsSinceEpoch.toString()}]',
    );
    await FirebaseFirestore.instance.collection('Products').doc(uid).set(
      {
        _now: {
          'name': name.toLowerCase().trim(),
          'mesureType': mesureType.trim(),
          'ingredientType': type!.trim(),
        },
      },
      SetOptions(merge: true),
    );
    debugPrint('--FIREBASE-- Writing: Products/$uid/$_now');

    reset();
  }

  void reset() {
    type = '';
    expiration = null;
    mesureValue = 0;
    mesureType = 'g';
    explainAccess = false;
    explainQuantity = false;
    explainExpiration = false;
    notifyListeners();
  }
}
