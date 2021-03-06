// import 'package:apple_sign_in/apple_sign_in.dart';
// import 'package:apple_sign_in/apple_sign_in.dart' as apple_sign_in;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/utils/platform_dialog.dart';
import 'package:myxmi/utils/platform_exception_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? status;
  FirebaseAuthException? error;

  Stream<User?> userStream() {
    final Stream<User?> _stream = firebaseAuth.userChanges();
    return _stream;
  }

  Future getUser({UserProvider? userProvider}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool authSignedIn = prefs.getBool('auth') ?? false;
    final User? user = firebaseAuth.currentUser;
    if (authSignedIn == true) {
      if (user != null) {
        userProvider!.account = user;
      }
    }
  }

  Future<User?> newUserEmailPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final String _email = email.trim();
    final String _password = password.trim();
    final currentUser = await firebaseAuth
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .whenComplete(
      () async {
        signInWithEmailPassword(
          context: context,
          email: _email,
          password: _password,
        ).whenComplete(
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const App(),
              ),
            );
          },
        );
        await sendEmail();
      },
    );
    final User? user = currentUser.user;
    return user;
  }

  Future<dynamic> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final String _email = email.trim();
    final String _password = password.trim();
    final SharedPreferences prefs = await _prefs;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (!foundation.kDebugMode && !foundation.kIsWeb) return;
      await prefs.setBool('is_logged_in', true);
      return status = 'success';
    } on FirebaseAuthException catch (_error) {
      debugPrint('errorCode:$_error');
      error = _error;
      debugPrint('----Error-----: $error----');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
            child: Text(
              'error'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          content: Text(_error.code),
          actions: <Widget>[
            RawMaterialButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      if (error?.code != null) status = error!.code;
      return status;
    }
  }

  Future sendEmail() async {
    return firebaseAuth.currentUser!.sendEmailVerification();
  }

  Future reload() async {
    return firebaseAuth.currentUser!.reload();
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          //  ScaffoldMessenger.of(context).showSnackBar(
          //     customSnackBar(
          //       content:
          //           'The account already exists with a different credential.',
          //     ),
          //   );
        } else if (e.code == 'invalid-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   customSnackBar(
          //     content: 'Error occurred while accessing credentials. Try again.',
          //   ),
          // );
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   customSnackBar(
        //     content: 'Error occurred using Google Sign-In. Try again.',
        //   ),
        // );
      }
    }
    debugPrint('Signed-in User: ${user?.email} ${user?.displayName}');
    return user;
  }

  // Future<void> signInWithApple(BuildContext context) async {
  //   try {
  //     final user = await _signInWithApple(
  //         scopes: [apple_sign_in.Scope.email, apple_sign_in.Scope.fullName],
  //         context: context);
  //     debugPrint('uid: ${user.uid}');
  //   } catch (e) {
  //     debugPrint('$e');
  //   }
  // }

  // Future<User> _signInWithApple(
  //     {List<Scope> scopes = const [], BuildContext context}) async {
  //   User user;
  //   final result = await AppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   switch (result.status) {
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );

  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );

  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential;
  //       final oAuthProvider = OAuthProvider('apple.com');
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //         accessToken:
  //             String.fromCharCodes(appleIdCredential.authorizationCode),
  //       );
  //       try {
  //         final UserCredential userCredential =
  //             await FirebaseAuth.instance.signInWithCredential(credential);
  //         user = userCredential.user;
  //         debugPrint(
  //             "New user: ${userCredential.additionalUserInfo.isNewUser}");
  //         debugPrint("USER: ${user.email}");
  //       } on FirebaseAuthException catch (e) {
  //         if (e.code == 'account-exists-with-different-credential') {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             customSnackBar(
  //               content:
  //                   'The account already exists with a different credential.',
  //             ),
  //           );
  //         } else if (e.code == 'invalid-credential') {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             customSnackBar(
  //               content:
  //                   'Error occurred while accessing credentials. Try again.',
  //             ),
  //           );
  //         }
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           customSnackBar(
  //             content: 'Error occurred using Apple Sign-In. Try again.',
  //           ),
  //         );
  //       }
  //       debugPrint('User: ${user.email} ${user.displayName}');
  //       return user;
  //   }
  //   return user;
  // }

  Future<dynamic> resetPassword({required String emailCtrl}) async {
    await firebaseAuth.sendPasswordResetEmail(email: emailCtrl);
  }

  Future<dynamic> signInAnonymously() {
    return firebaseAuth.signInAnonymously().then(
      (firebaseUser) {
        return firebaseUser.user;
      },
    );
  }

  Future<dynamic> deleteUser() {
    return firebaseAuth.currentUser!.delete();
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final bool? didRequestSignOut = await PlatformAlertDialog(
      title: 'logout'.tr(),
      content: 'logoutAreYouSure'.tr(),
      cancelActionText: 'cancel'.tr(),
      defaultActionText: 'logout'.tr(),
    ).show(context);

    if (didRequestSignOut == true) {
      await _signOut(context: context);
    }
  }

  Future<void> _signOut({BuildContext? context}) async {
    final ProgressDialog pr = ProgressDialog(context: context);

    pr.show(max: 1000, msg: '${'loading'.tr()}...', barrierDismissible: true);
    try {
      await signOut().whenComplete(
        () async {
          pr.close();
          final SharedPreferences prefs = await _prefs;
          await prefs.setBool('is_logged_in', false);
        },
      );
    } on PlatformException catch (e) {
      pr.close();
      await PlatformExceptionAlertDialog(
        title: 'logoutFailed'.tr(),
        exception: e,
      ).show(context!);
    }
  }

  Future signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final bool _google = googleSignIn.currentUser?.email != null;
    if (_google) {
      await googleSignIn.signOut().then(
        (google) async {
          await google!.clearAuthCache();
          await firebaseAuth.signOut().then(
            (firebase) {
              debugPrint('Google-Auth: Signed-Out user');
            },
          );
        },
      );
    } else {
      await firebaseAuth.signOut().then(
        (firebase) {
          debugPrint('Email/Password-Auth: Signed-Out user');
        },
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
