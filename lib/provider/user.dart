import 'package:firebase_auth/firebase_auth.dart';

class UserProvider {
  User account;
  String timeEmailSent;

  changeUser({User newUser}) {
    account = newUser;
  }
}
