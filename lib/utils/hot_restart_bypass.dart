import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  ///Saves the Login State (true) for LoggedIn and (false) for LoggedOut
  Future saveLoginState({bool isLoggedIn}) async {
    //Ignore Operation if Not in DebugMode on Web
    if (!foundation.kDebugMode && !foundation.kIsWeb) return;
    final SharedPreferences _prefs = await prefs;
    _prefs.setBool('is_logged_in', isLoggedIn);
  }

  ///Gets the login status from SharedPreferences
  static Future<bool> getLoginStatus() async {
    final SharedPreferences _prefs = await prefs;
    return _prefs.getBool('is_logged_in') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getLoginStatus(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data) {
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


// //Usage In StreamBuilder
// StreamBuilder(
//   stream: FirebaseAuth.instance.authStateChanges(),
//   builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return HomePage();
//       } else {
//         //Only in Debug Mode & in Web
//         if (Foundation.kDebugMode && Foundation.kIsWeb) {
//           //---------------------HOT RESTART BYPASS--------------------------
//           return HotRestartByPassBuilder(
//             destinationFragment: HomePage(),
//             loginFragment: LoginPage(),
//           );
//           //-----------------------------------------------------------------
//         } else {
//           return LoginPage();
//         }
//       }
//     },
// );
