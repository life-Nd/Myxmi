import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:sizer/sizer.dart';
import 'package:myxmi/app.dart';
import 'providers/prefs.dart';
import 'providers/user.dart';
import 'services/auth.dart';
import 'utils/hot_restart_bypass.dart';

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

final prefProvider =
    ChangeNotifierProvider<PreferencesProvider>((ref) => PreferencesProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  kIsWeb
      ?? FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primaryColor: Colors.white,
    primaryColorBrightness: Brightness.light,
    primaryColorLight: Colors.grey.shade100,
    primaryColorDark: Colors.grey.shade800,
    canvasColor: Colors.grey.shade400,
    accentColor: const Color(0xff457BE0),
    accentColorBrightness: Brightness.light,
    fontFamily: 'Georgia',
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(),
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.white,
      brightness: Brightness.light,
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
      elevation: 1,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardColor: const Color(0xFFF5F5F5),
    dividerColor: const Color(0x1f6D42CE),
    highlightColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    focusColor: const Color(0xDD000000),
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(2),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primaryColor: const Color(0xFF212121),
    fontFamily: 'Georgia',
    primaryColorBrightness: Brightness.dark,
    primaryColorLight: Colors.grey.shade200,
    primaryColorDark: Colors.grey.shade800,
    canvasColor: Colors.grey.shade400,
    accentColor: const Color(0xff457BE0),
    accentColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xDD000000),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(),
    appBarTheme: const AppBarTheme(
      brightness: Brightness.dark,
      color: Colors.black,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(color: Colors.white),
      elevation: 1,
    ),
    bottomAppBarColor: const Color(0xff6D42CE),
    cardColor: const Color(0xFF303030),
    dividerColor: const Color(0x1f6D42CE),
    buttonColor: const Color(0xFF303030),
    focusColor: const Color(0xFFFFFFFF),
    highlightColor: Colors.black,
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(2),
    ),
  );

  runApp(
    Sizer(builder: (context, orientation, deviceType) {
      return EasyLocalization(
        path: 'translations',
        supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
        child: ProviderScope(
          child: Consumer(builder: (context, watch, child) {
            final _pref = watch(prefProvider);
            return FutureBuilder(
                future: _pref.readPrefs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data[0] != null) {
                        final ThemeMode _storedTheme = snapshot.data[0] == 'Light'
                        ? ThemeMode.light
                        : ThemeMode.dark;
                      return Sizer(builder: (context, orientation, deviceType) {
                        return MaterialApp(
                            localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: context.locale,
                        theme: lightTheme,
                        darkTheme: darkTheme,
                        themeMode: _storedTheme,
                        debugShowCheckedModeBanner: false,
                        home: Root(),
                      );
                      });
                    } else {
                    return MaterialApp(
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      theme: lightTheme,
                      darkTheme: darkTheme,
                      themeMode: ThemeMode.light,
                      debugShowCheckedModeBanner: false,
                      home: Root(),
                    );
                  }
                });
          }),
        ),
        );
    }
    ),
  );
}

class Root extends HookWidget {
  @override
  Widget build(BuildContext context) {
    if (foundation.kDebugMode && foundation.kIsWeb) {
      return HotRestartByPassBuilder(
        destinationFragment: App(),
        loginFragment: _StreamAuthBuilder(),
      );
    }
    return _StreamAuthBuilder();
  }
}

class _StreamAuthBuilder extends HookWidget {
  final AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final _userProvider = watch(userProvider);
      return StreamBuilder<User>(
        stream: _authServices.userStream(),
        builder: (context, AsyncSnapshot<User> snapUser) {
          _userProvider.changeUser(newUser: snapUser.data);
          return App();
        },
      );
    });
  }
}
