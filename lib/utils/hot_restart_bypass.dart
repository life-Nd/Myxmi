import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class HotRestartByPassBuilder extends StatelessWidget {
  final Widget destinationFragment;
  final Widget loginFragment;
  const HotRestartByPassBuilder({
    Key key,
    this.destinationFragment,
    this.loginFragment,
  }) : super(key: key);

  static final Future<SharedPreferences> prefs =
      SharedPreferences.getInstance();

  ///Gets the login status from SharedPreferences
  static Future<bool> getLoginStatus() async {
    final SharedPreferences _prefs = await prefs;
    return _prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building hotRestart');
    final _userProvider = useProvider(userProvider);
    return FutureBuilder<bool>(
      future: getLoginStatus(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data) {
            _userProvider.account = FirebaseAuth?.instance?.currentUser;
            return destinationFragment;
          } else {
            return loginFragment;
          }
        } else {
          return loginFragment;
        }
      },
    );
  }
}
