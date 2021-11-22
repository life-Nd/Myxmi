import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/app.dart';

class UserProvider extends ChangeNotifier {
  User account;
  String timeEmailSent;
  Map<String, dynamic> favorites = {};


  Future changeUsername({String newName}) async {
    await account.updateDisplayName(newName);
    account.reload();
    notifyListeners();
  }

  void signedOut() {
    account = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future changeUserPhoto({BuildContext context, String photoUrl}) async {
    await account.updatePhotoURL(photoUrl).whenComplete(
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => App(),
            ),
          ),
        );
  }
    Future deleteAccount() async {
    await account.delete();
    account.reload();
    notifyListeners();
  }

}
