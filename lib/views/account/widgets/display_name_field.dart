import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../../../main.dart';

class DisplayNameField extends HookWidget {
  final TextEditingController _nameCtrl = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  DisplayNameField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final ProgressDialog pr = ProgressDialog(context: context);

    return TextField(
      controller: _nameCtrl,
      focusNode: _nameNode,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.all(0),
        labelText: 'displayName'.tr(),
        labelStyle: TextStyle(
          fontSize: 20,
          color: Theme.of(context).textTheme.bodyText1.color,
          fontWeight: FontWeight.w700,
        ),
        hintText: _user?.account?.displayName,
        suffixIcon: _nameCtrl.text.isEmpty
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              )
            : IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.green,
                ),
                onPressed: () {
                  _nameNode.unfocus();
                  _nameNode.canRequestFocus = false;
                  pr.show(max: 100, msg: 'loading'.tr());
                  _user.changeUsername(newName: _nameCtrl.text);
                  // AuthServices().reload();
                  Future.delayed(const Duration(seconds: 2), () {
                    pr.close();
                  });
                },
              ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
