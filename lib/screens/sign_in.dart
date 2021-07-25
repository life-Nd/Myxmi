import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/services/auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as apple_sign_in;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:universal_io/io.dart';
import '../widgets/dialog_no_account_found.dart';
import '../widgets/dialog_reset_password.dart';
import '../widgets/dialog_unknown_error.dart';
import '../widgets/dialog_wrong_password.dart';

final _fieldsProvider =
    ChangeNotifierProvider<_FieldsNotifier>((ref) => _FieldsNotifier());

TextEditingController _emailCtrl;
TextEditingController _passwordCtrl;
final AuthServices _authServices = AuthServices();
FocusNode _passwordNode;

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInState();
}

class SignInState extends State<SignIn> {
  static final GlobalKey _containerKey = GlobalKey();

  bool showPassword = false;
  bool showButton = false;

  @override
  void initState() {
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    debugPrint('Building widget');
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
                Consumer(builder: (context, watch, child) {
                  final _view = watch(viewProvider);
                  debugPrint('Building row');
                  return _view.authenticating
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : RawMaterialButton(
                          fillColor: const Color.fromRGBO(64, 123, 255, 32),
                          elevation: 15,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            _view.loadingAuth(loading: true);
                            _authServices
                                .signInWithEmailPassword(
                                    email: _emailCtrl.text,
                                    password: _passwordCtrl.text,
                                    context: context)
                                .then(
                              (value) {
                                debugPrint('Value:$value');
                                _view.loadingAuth(loading: false);
                                debugPrint(
                                    'Status value:${_authServices.status}');
                                switch (_authServices.status) {
                                  case 'success':
                                    _view.view = 0;
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
}

class _EmailWithValidator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Consumer(builder: (_, watch, __) {
        final _fields = watch(_fieldsProvider);
        return TextField(
          controller: _emailCtrl,
          onChanged: (value) {
            _fields.validateEmail(value);
          },
          onSubmitted: (submitted) {
            FocusScope.of(context).requestFocus(_passwordNode);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: 'enterEmail'.tr(),
            errorText: _fields.errorMsgEmail,
          ),
        );
      }),
    );
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Consumer(builder: (_, watch, __) {
        final _fields = watch(_fieldsProvider);
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
      }),
    );
  }
}

class _FieldsNotifier with ChangeNotifier {
  String errorMsgEmail;
  String errorMsgPassword;
  bool obscurePassword = true;
  void validateEmail(String value) {
    value.trim();
    if (_emailCtrl.text != null) {
      if (value.isEmpty) {
        errorMsgEmail = "Email can't be empty";
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        errorMsgEmail = 'Enter a correct email address';
      } else {
        errorMsgEmail = null;
      }

      notifyListeners();
    }
  }

  void validatePassword(String value) {
    value.trim();
    if (_emailCtrl.text != null) {
      if (value.isEmpty) {
        errorMsgPassword = "Email can't be empty";
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
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
