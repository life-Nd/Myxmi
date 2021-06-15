import 'package:myxmi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../app.dart';
import '../main.dart';
import 'loading_alert.dart';

class NameField extends StatefulWidget {
  final String name;

  const NameField({this.name = ''});
  createState() => NameFieldState();
}

class NameFieldState extends State<NameField> {
  final TextEditingController _nameCtrl = TextEditingController();
  initState() {
    _nameCtrl.text = widget.name;
    super.initState();
  }

  Widget build(BuildContext context) {
    return TextField(
      controller: _nameCtrl,
      decoration: InputDecoration(
        focusColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: '${widget.name}',
        suffixIcon: Consumer(builder: (context, watch, child) {
          final _user = watch(userProvider);
          return IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.green,
            ),
            onPressed: () {
              loadingAlertDialog(
                context: context,
              );
              _user.account.updateDisplayName('${_nameCtrl.text}');

              _nameCtrl.clear();
              AuthHandler().reload();
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => App(),
                    ),
                    (route) => false);
              });
            },
          );
        }),
      ),
    );
  }
}
