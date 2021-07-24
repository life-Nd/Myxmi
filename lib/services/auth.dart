import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:myxmi/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../main.dart';
import 'platform_dialog.dart';
import 'platform_exception_dialog.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String status;
  FirebaseAuthException error;

  Stream<User> userStream() {
    final Stream<User> _stream = firebaseAuth.userChanges();
    return _stream;
  }

  Future getUser({UserProvider userProvider}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool authSignedIn = prefs.getBool('auth') ?? false;
    final User user = firebaseAuth.currentUser;
    if (authSignedIn == true) {
      if (user != null) {
        userProvider.changeUser(newUser: user);
      }
    }
  }

  Future<User> newUserEmailPassword({
    @required BuildContext context,
    String email,
    String password,
  }) async {
    final String _email = email.trim();
    final String _password = password.trim();
    final currentUser = await firebaseAuth
        .createUserWithEmailAndPassword(email: _email, password: _password)
        .whenComplete(() async {
      signInWithEmailPassword(
          email: _email, password: _password, context: context);
      await sendEmail();
    });
    final User user = currentUser.user;
    return user;
  }

  Future<dynamic> signInWithEmailPassword(
      {@required BuildContext context, String email, String password}) async {
    final String _email = email.trim();
    final String _password = password.trim();
    final SharedPreferences prefs = await _prefs;
  
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: _email, password: _password)
          .whenComplete(()async {
         
        if (!foundation.kDebugMode && !foundation.kIsWeb) return;
        prefs.setBool('is_logged_in', true);
        status = 'success';
         Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context1) => Root()), (route) => false);
      });

      return status;
    } on FirebaseAuthException catch (_error) {
      debugPrint('----Error-----: $error----');
      debugPrint('errorCode:$_error');

      error = _error;
      if (error?.code != null) status = error.code;
      return status;
    }
  }

  Future sendEmail() async {
    return firebaseAuth.currentUser.sendEmailVerification();
  }

  Future reload() async {
    return firebaseAuth.currentUser.reload();
  }

  static Future<User> signInWithGoogle({@required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
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

        debugPrint("USER: ${user.email}");
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (_) => Root(),
        //     ),
        //     (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }

    debugPrint('User: ${user.email} ${user.displayName}');
    return user;
  }

  Future<User> signInWithApple(
      {List<Scope> scopes = const [], BuildContext context}) async {
    User user;
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );

      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        try {
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          user = userCredential.user;
          debugPrint(
              "New user: ${userCredential.additionalUserInfo.isNewUser}");

          debugPrint("USER: ${user.email}");
          // _showLoading = false;
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //       builder: (_) => Root(),
          //     ),
          //     (route) => false);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'The account already exists with a different credential.',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              content: 'Error occurred using Apple Sign-In. Try again.',
            ),
          );
        }
        debugPrint('User: ${user.email} ${user.displayName}');
        return user;
    }
    return user;
  }

  Future<dynamic> resetPassword({String emailCtrl}) async {
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
    return firebaseAuth.currentUser.delete();
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'logout'.tr(),
      content: 'logoutAreYouSure'.tr(),
      cancelActionText: 'cancel'.tr(),
      defaultActionText: 'logout'.tr(),
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final ProgressDialog pr = ProgressDialog(context: context);
    Navigator.of(context).pop();
    pr.show(max: 1000, msg: '${'loading'.tr()}...', barrierDismissible: true);
    try {
      signOut(context).whenComplete(() async {
        pr.close();
        final SharedPreferences prefs = await _prefs;
        prefs.setBool('is_logged_in', false);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => Root(),
            ),
            (route) => false);
      });
    } on PlatformException catch (e) {
      pr.close();
      await PlatformExceptionAlertDialog(
        title: 'logoutFailed'.tr(),
        exception: e,
      ).show(context);
    }
  }

  Future signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final bool _google = googleSignIn.currentUser?.email != null;
    debugPrint("GOOGLE: ${googleSignIn.currentUser?.email != null}");
    if (_google) {
      googleSignIn.currentUser.clearAuthCache();
      googleSignIn.signOut().then((google) {
        google.clearAuthCache();
        firebaseAuth.signOut().then(
          (firebase) {
            debugPrint('Firebase of Google Signed-Out user');
          },
        );
      });
    } else {
      firebaseAuth.signOut().then(
        (firebase) {
          debugPrint('Firebase Signed-Out user');
        },
      );
      debugPrint('Completed');
    }
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
