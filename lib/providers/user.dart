import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/app.dart';

class UserProvider extends ChangeNotifier {
  User account;
  String timeEmailSent;
  Map<String, dynamic> favorites = {};
  bool onMobileApp;

  Future changeUsername({String newName}) async {
    await account.updateDisplayName(newName);
    account.reload();
    notifyListeners();
  }

  Future changeUserPhoto({BuildContext context, String photoUrl}) async {
    await account.updatePhotoURL(photoUrl);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => App(),
      ),
    );
    notifyListeners();
  }
}
