import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myxmi/widgets/loading_alert.dart';
import '../app.dart';
import 'platform_dialog.dart';
import 'platform_exception_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

bool _showLoading = true;

class AuthHandler {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> newUserEmailPassword({
    String email,
    String password,
    BuildContext context,
  }) async {
    String _email = email.trim();
    String _password = password.trim();

    _showLoading
        ? loadingAlertDialog(context: context)
        : print('!!LOADING COMPLETED!!');
    final currentUser = await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    )
        .whenComplete(() async {
      await signInWithEmailPassword(
        email: _email,
        password: _password,
        context: context,
      );

      await sendEmail();
    });
    Future.delayed(Duration(milliseconds: 777), () {
      _showLoading = false;
    });
    User user = currentUser.user;
    return user;
  }

  Future<dynamic> signInWithEmailPassword({
    String email,
    String password,
    BuildContext context,
  }) async {
    String _email = email.trim();
    String _password = password.trim();

    _showLoading
        ? loadingAlertDialog(context: context)
        : print('!!LOADING COMPLETED!!');
    try {
      await trySignIn(context, _email, _password);
    } catch (error) {
      print('Error-----: $error----');
      _showLoading = false;
      if (error.code != null && error?.code == 'user-not-found') {
        dialogNoAccoundFound(context, error, _email, _password);
      } else {
        _showLoading = false;
        dialogWrongPassword(context, error, _email, email);
      }
    }
  }

  trySignIn(BuildContext context, String _email, String _password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    );
    Future.delayed(Duration(milliseconds: 444), () {
      _showLoading = false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => App(),
          ),
          (route) => false);
    });
 
  }

  Future<dynamic> dialogNoAccoundFound(
      BuildContext context, error, String _email, String _password) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: EdgeInsets.only(top: 40, bottom: 40),
          title: Center(
            child: Text(
              '${'error'.tr()}',
              style: TextStyle(color: Colors.red),
            ),
          ),
          content: ListTile(
            subtitle: Text('${error.message.toString()}'),
            title: Text(
              '${'noAccountFound'.tr()}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
          actions: [
            _RetryButton(),
            RawMaterialButton(
              padding: EdgeInsets.all(4),
              elevation: 20,
              fillColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'signUp'.tr(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                newUserEmailPassword(
                  email: _email,
                  password: _password,
                  context: context,
                );
              },
            )
          ],
        );
      },
    );
  }

  Future<dynamic> dialogWrongPassword(
      BuildContext context, error, String _email, String email) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: EdgeInsets.only(top: 40, bottom: 40),
            title: Center(
              child: Text(
                'error'.tr(),
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: ListTile(
              title: Text('${error?.message.toString()}'),
              subtitle: RawMaterialButton(
                child: Text(
                  'forgotPass'.tr(),
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  dialogResetLink(context, _email, email);
                },
              ),
            ),
            actions: [_RetryButton()],
          );
        });
  }

  Future<dynamic> dialogResetLink(
      BuildContext context, String _email, String email) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: EdgeInsets.only(top: 40, bottom: 40),
          title: Text(
            'confirm'.tr(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('sendResetLink'.tr()),
                subtitle: Text(
                  'checkEmail'.tr(),
                ),
              ),
              Text(
                '$_email',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            RawMaterialButton(
              child: Text('reset'.tr()),
              onPressed: () {
                resetPassword(emailCtrl: email);
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      insetPadding: EdgeInsets.only(top: 40, bottom: 40),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'checkEmail'.tr(),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: Colors.green,
                          ),
                        ],
                      ),
                      actions: [
                        RawMaterialButton(
                          child: Text(
                            'close'.tr(),
                          ),
                          onPressed: () {
                            _showLoading = false;
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future sendEmail() {
    return _firebaseAuth.currentUser.sendEmailVerification();
  }

  Future reload() {
    return _firebaseAuth.currentUser.reload();
  }

  static Future<User> signInWithGoogle({@required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    _showLoading
        ? loadingAlertDialog(context: context)
        : print('!!LOADING COMPLETED!!');

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

        print("USER: ${user.email}");
        _showLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => App(),
            ),
            (route) => false);
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

    print('User: ${user.email} ${user.displayName}');
    return user;
  }

  Future<User> signInWithApple({
    List<Scope> scopes = const [],
    BuildContext context,
  }) async {
    _showLoading
        ? loadingAlertDialog(context: context)
        : print('!!LOADING COMPLETED!!');
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
          print("New user: ${userCredential.additionalUserInfo.isNewUser}");

          print("USER: ${user.email}");
          _showLoading = false;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => App(),
              ),
              (route) => false);
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
        print('User: ${user.email} ${user.displayName}');
        return user;
    }
    return user;
  }

  Future<dynamic> resetPassword({String emailCtrl}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: emailCtrl);
  }

  Future<dynamic> signInAnonymously() {
    return _firebaseAuth.signInAnonymously().then(
      (firebaseUser) {
        return firebaseUser.user;
      },
    );
  }

  Future<dynamic> deleteUser() {
    return _firebaseAuth.currentUser.delete();
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: "${'logout'.tr()}",
      content: "${'logoutAreYouSure'.tr()}",
      cancelActionText: "${'cancel'.tr()}",
      defaultActionText: "${'logout'.tr()}",
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthHandler _authHandler = AuthHandler();
      await _authHandler.signOut(context);
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: "${'logoutFailed'.tr()}",
        exception: e,
      ).show(context);
    }
  }

  Future signOut(context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    bool _google = googleSignIn.currentUser?.email != null;
    print("GOOGLE: ${googleSignIn.currentUser?.email != null}");
    if (_google) {
      googleSignIn.currentUser.clearAuthCache();
      googleSignIn.signOut().then((google) {
        google.clearAuthCache();
        _firebaseAuth.signOut().then(
          (firebase) {
            print('Firebase of Google Signed-Out user');
          },
        );
      });
    } else {
      _firebaseAuth.signOut().then(
        (firebase) {
          print('Firebase Signed-Out user');
        },
      );
      print('Completed');
    }
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: RawMaterialButton(
        child: Text("${'retry'.tr()}"),
        onPressed: () {
          _showLoading = false;
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
