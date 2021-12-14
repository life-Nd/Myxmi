import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/home/home_screen.dart';
import 'package:myxmi/streams/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (foundation.kDebugMode && foundation.kIsWeb) {
      // This avoids Auth disconnections on web when reloading in Debug Mode
      return _HotRestartByPassBuilder();
    }
    // If not web get data cached by FirebaseAuth or reload new data
    return const StreamAuthBuilder();
  }
}

class _HotRestartByPassBuilder extends StatelessWidget {
  static final Future<SharedPreferences> prefs =
      SharedPreferences.getInstance();

  ///Check if isLoggedIn locally
  static Future<bool> isLoggedIn() async {
    final SharedPreferences _prefs = await prefs;
    return _prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final _userProvider = ref.watch(userProvider);
        return FutureBuilder<bool>(
          future: isLoggedIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.data!) {
              // if not locally saved on web that isLoggedIn stream the user's infos from FirebaseAuth online
              return const StreamAuthBuilder();
            } else {
              // if locally saved on web that isLoggedIn get the user's infos from FirebaseAuth local storage
              _userProvider.account = FirebaseAuth.instance.currentUser;
              return HomeScreen();
            }
          },
        );
      },
    );
  }
}
