import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/auth.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/screens/auth/widgets/dialog_no_account_found.dart';
import 'package:myxmi/screens/auth/widgets/dialog_reset_password.dart';
import 'package:myxmi/screens/auth/widgets/dialog_unknown_error.dart';
import 'package:myxmi/screens/auth/widgets/dialog_wrong_password.dart';

final _fieldsProvider =
    ChangeNotifierProvider<_FieldsNotifier>((ref) => _FieldsNotifier());

final TextEditingController _emailCtrl = TextEditingController();
final TextEditingController _passwordCtrl = TextEditingController();

FocusNode _passwordNode = FocusNode();

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  State<SignInScreen> createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _auth = ref.watch(authProvider);
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                20,
              ),
              topLeft: Radius.circular(
                20,
              ),
              bottomRight: Radius.circular(
                20,
              ),
              bottomLeft: Radius.circular(
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
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _EmailWithValidator(),
                const SizedBox(height: 10),
                _PasswordField(),
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
                    Consumer(
                      builder: (context, ref, child) {
                        final _view = ref.watch(homeScreenProvider);
                        return _view.loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : RawMaterialButton(
                                fillColor:
                                    const Color.fromRGBO(64, 123, 255, 32),
                                elevation: 15,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                onPressed: () async {
                                  _view.loadingEntry(isLoading: true);
                                  await _auth
                                      .signInWithEmailPassword(
                                    email: _emailCtrl.text,
                                    password: _passwordCtrl.text,
                                  )
                                      .then(
                                    (value) {
                                      _view.loadingEntry(isLoading: false);
                                      debugPrint(
                                        'Status value:${_auth.status}',
                                      );
                                      switch (_auth.status) {
                                        case 'success':
                                          _view.changeView(index: 1);
                                          _emailCtrl.clear();
                                          _passwordCtrl.clear();

                                          break;
                                        case 'user-not-found':
                                          dialogNoAccountFound(
                                            context: context,
                                            email: _emailCtrl.text,
                                            password: _passwordCtrl.text,
                                            error: _auth.error,
                                          );
                                          break;
                                        case 'wrong-password':
                                          dialogWrongPassword(
                                            context: context,
                                            email: _emailCtrl.text,
                                            error: _auth.error,
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
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
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
                        _auth.signInWithGoogle(context: context);
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
                const SizedBox(
                  height: 50,
                ),
                // if (Platform.isIOS)
                //   Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     width: 200,
                //     alignment: Alignment.center,
                //     child: apple_sign_in.AppleSignInButton(
                //       style: apple_sign_in.ButtonStyle.black,
                //       cornerRadius: 20,
                //       type: apple_sign_in.ButtonType.continueButton,
                //       onPressed: () {
                //         _authServices.signInWithApple(context);
                //       },
                //     ),
                //   )
                // else
                //   const Text(''),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmailWithValidator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Consumer(
        builder: (_, ref, __) {
          final _fields = ref.watch(_fieldsProvider);
          return TextField(
            controller: _emailCtrl,
            onChanged: (value) {
              _fields.validateEmail(value);
            },
            onSubmitted: (submitted) {
              !kIsWeb
                  ? FocusScope.of(context).requestFocus(_passwordNode)
                  : debugPrint('web');
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: 'enterEmail'.tr(),
              errorText: _fields.errorMsgEmail,
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _PasswordField extends StatefulWidget {
  bool showPassword = false;
  bool showButton = false;
  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  @override
  void initState() {
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Consumer(
        builder: (_, ref, __) {
          final _fields = ref.watch(_fieldsProvider);
          return TextField(
            focusNode: _passwordNode,
            controller: _passwordCtrl,
            obscureText: _fields.obscurePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'enterPassword'.tr(),
              suffixIcon: IconButton(
                icon: _fields.obscurePassword
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () {
                  _fields.togglePasswordVisibity();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // @override
  // void dispose() {
  //   // Clean up the focus node when the Form is disposed.
  //   _passwordNode.dispose();

  //   super.dispose();
  // }

  // @override
  // void dispose() {
  //   _passwordCtrl.dispose();
  //   super.dispose();
  // }
}

class _FieldsNotifier with ChangeNotifier {
  String? errorMsgEmail;
  String? errorMsgPassword;
  bool obscurePassword = true;
  void validateEmail(String value) {
    value.trim();
    if (_emailCtrl.text.isNotEmpty) {
      if (value.isEmpty) {
        errorMsgEmail = "Email can't be empty";
      } else if (!value.contains(
        RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ),
      )) {
        errorMsgEmail = 'Enter a correct email address';
      } else {
        errorMsgEmail = null;
      }

      notifyListeners();
    }
  }

  void validatePassword(String value) {
    value.trim();
    if (_emailCtrl.text.isNotEmpty) {
      if (value.isEmpty) {
        errorMsgPassword = "Email can't be empty";
      } else if (!value.contains(
        RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ),
      )) {
        errorMsgPassword = 'Enter a correct email address';
      } else {
        errorMsgPassword = null;
      }

      notifyListeners();
    }
  }

  void togglePasswordVisibity() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }
}
