import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/app.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

class UserProvider extends ChangeNotifier {
  User? account;
  String? timeEmailSent;
  bool isConnected = true;
  Map<String, dynamic> favorites = {};

  Future changeUsername({String? newName}) async {
    await account!.updateDisplayName(newName);
    account!.reload();
    notifyListeners();
  }

  void connected() {
    isConnected = !isConnected;
    notifyListeners();
  }

  void signedOut() {
    account = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future changeUserPhoto({BuildContext? context, String? photoUrl}) async {
    await account!.updatePhotoURL(photoUrl).whenComplete(
          () => Navigator.of(context!).push(
            MaterialPageRoute(
              builder: (_) => const App(),
            ),
          ),
        );
  }

  Future deleteAccount() async {
    await account!.delete();
    account!.reload();
    notifyListeners();
  }
}
