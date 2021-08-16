import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'main.dart';
import 'screens/home.dart';
import 'utils/hot_restart_bypass.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    if (foundation.kDebugMode && foundation.kIsWeb) {
      return Consumer(builder: (_, watch, __) {
        final _user = FirebaseAuth.instance.currentUser;
        return HotRestartByPassBuilder(
          destinationFragment: Home(
            uid: _user?.uid,
          ),
          loginFragment: _StreamAuthBuilder(),
        );
      });
    }
    return _StreamAuthBuilder();
  }
}

class _StreamAuthBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, AsyncSnapshot<User> snapUser) {
        if (snapUser.data != null) {
          final _user = context.read(userProvider);
          _user.account = snapUser.data;
          return Home(
            uid: _user?.account?.uid,
          );
        }
        return const Home(
          uid: null,
        );
      },
    );
  }
}
