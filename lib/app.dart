import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  static const String route = '/';
  @override
  Widget build(BuildContext context) {
    if (foundation.kDebugMode && foundation.kIsWeb) {
      // This avoids Auth disconnections on web when reloading in Debug Mode
      return _HotRestartByPassBuilder();
    }
    // If not web get data cached by FirebaseAuth or reload new data
    return _StreamAuthBuilder();
  }
}

class _StreamAuthBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, AsyncSnapshot<User> snapUser) {
        final _user = context.read(userProvider);
        _user.account = snapUser.data;
        return Home();
      },
    );
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
    return Consumer(builder: (_, watch, __) {
      final _userProvider = watch(userProvider);
      
      
      return FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data) {
              // if locally saved on web that isLoggedIn get the user's infos from FirebaseAuth local storage
              _userProvider.account = FirebaseAuth?.instance?.currentUser;
              return Home();
            } else {
              // if not locally saved on web that isLoggedIn stream the user's infos from FirebaseAuth online
              return _StreamAuthBuilder();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    });
  }
}
