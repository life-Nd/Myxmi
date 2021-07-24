import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/services/auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as apple_sign_in;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:universal_io/io.dart';
import 'dialog_no_account_found.dart';
import 'dialog_reset_password.dart';
import 'dialog_unknown_error.dart';
import 'dialog_wrong_password.dart';

TextEditingController _emailCtrl;
TextEditingController _passwordCtrl;

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final GlobalKey _containerKey = GlobalKey();

  bool _obscure = true;
  bool showPassword = false;
  bool showButton = false;
  bool _isEditingEmail = false;
  final AuthServices _authServices = AuthServices();

  FocusNode _passwordNode;
  @override
  void initState() {
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _passwordNode = FocusNode();
    super.initState();
  }

  String _validateEmail(String value) {
    value.trim();
    if (_emailCtrl.text != null) {
      if (value.isEmpty) {
        return "Email can't be empty";
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      key: _containerKey,
      height: _size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(
            20,
          ),
          topLeft: Radius.circular(
            20,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'signIn'.tr(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _emailCtrl,
                onChanged: (value) {
                  setState(() {
                    _isEditingEmail = true;
                  });
                },
                onSubmitted: (submitted) {
                  FocusScope.of(context).requestFocus(_passwordNode);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'enterEmail'.tr(),
                  errorText:
                      _isEditingEmail ? _validateEmail(_emailCtrl.text) : null,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StatefulBuilder(
              builder: (context, StateSetter setState) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextField(
                    focusNode: _passwordNode,
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'enterPassword'.tr(),
                      suffixIcon: IconButton(
                        icon: _obscure
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          _obscure = !_obscure;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: RawMaterialButton(
                onPressed: () {
                  dialogResetPassword(
                    context: context,
                    email: _emailCtrl.text,
                  );
                },
                child: Text(
                  'forgotPass'.tr(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Consumer(builder: (context, watch, child) {
                  final _view = watch(viewProvider);
                  return RawMaterialButton(
                    fillColor: const Color.fromRGBO(64, 123, 255, 32),
                    elevation: 15,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      _view.view = 0;
                      await _authServices
                          .signInWithEmailPassword(
                              email: _emailCtrl.text,
                              password: _passwordCtrl.text,
                              context: context)
                          .whenComplete(
                        () {
                          debugPrint('Status value:${_authServices.status}');
                          switch (_authServices.status) {
                            case 'success':
                              break;
                            case 'user-not-found':
                              dialogNoAccountFound(
                                context: context,
                                email: _emailCtrl.text,
                                password: _passwordCtrl.text,
                                error: _authServices.error,
                              );
                              break;
                            case 'wrong-password':
                              dialogWrongPassword(
                                context: context,
                                email: _emailCtrl.text,
                                error: _authServices.error,
                              );
                              break;
                            case 'null':
                              dialogUnknownError(context: context);
                          }
                        },
                      );
                    },
                    child: Text(
                      'signIn'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(
              height: _size.height / 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white,
                  onPressed: () {
                    AuthServices.signInWithGoogle(context: context);
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        padding: const EdgeInsets.all(4),
                        child: Image.asset('assets/google_logo.png'),
                      ),
                      Text(
                        'signInWithGoogle'.tr(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _size.height / 20,
            ),
            if (!Platform.isAndroid && Platform.isIOS)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: _size.width / 3,
                alignment: Alignment.center,
                child: apple_sign_in.AppleSignInButton(
                  style: apple_sign_in.ButtonStyle.black,
                  cornerRadius: 20,
                  type: apple_sign_in.ButtonType.continueButton,
                  onPressed: () {
                    _signInWithApple(context);
                  },
                ),
              )
            else
              const Text(''),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final AuthServices _authServices = AuthServices();
      final user = await _authServices.signInWithApple(
          scopes: [apple_sign_in.Scope.email, apple_sign_in.Scope.fullName],
          context: context);
      debugPrint('uid: ${user.uid}');
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordNode.dispose();

    super.dispose();
  }
}
