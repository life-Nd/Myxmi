import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'main.dart';
import 'screens/home.dart';
import 'utils/hot_restart_bypass.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    debugPrint('building root');
    if (foundation.kDebugMode && foundation.kIsWeb) {
      return HotRestartByPassBuilder(
        destinationFragment: Home(),
        loginFragment: _StreamAuthBuilder(),
      );
    }
    return _StreamAuthBuilder();
  }
}

class _StreamAuthBuilder extends HookWidget {
  final consumer = Consumer(builder: (_, watch, __) {
    final _user = watch(userProvider);
    final _auth = watch(firebaseAuth);
    return StreamBuilder<User>(
      stream: _auth.userChanges(),
      builder: (context, AsyncSnapshot<User> snapUser) {
        if (snapUser.connectionState == ConnectionState.waiting) {
          debugPrint('----snapUser loading');
          debugPrint('--loading user');
        }
        if (snapUser.data != null) {
          _user.account = snapUser.data;
        }
        return Home();
      },
    );
  });
  @override
  Widget build(BuildContext context) {
    debugPrint('building streambuilder');
    return consumer;
  }
}
