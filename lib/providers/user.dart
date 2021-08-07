import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User account;
  String timeEmailSent;
  Map<String, dynamic> favorites = {};

  Future changeUsername({String newName}) async {
    await account.updateDisplayName(newName);
    account.reload();
    notifyListeners();
  }

  Future changeUserPhoto({String newPhoto}) async {
    await account.updatePhotoURL(newPhoto);
    account.reload();
    notifyListeners();
  }
}
