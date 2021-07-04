import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/services/auth.dart';
import 'package:myxmi/widgets/details_tile.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../main.dart';

final TextEditingController _nameCtrl = TextEditingController();
final _nameNode = FocusNode();

class AccountScreen extends HookWidget {
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final Size _size = MediaQuery.of(context).size;
    final ProgressDialog pr = ProgressDialog(context: context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${'profile'.tr()}'),
      ),
      body: Container(
          height: _size.height,
          width: _size.width / 1.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(1),
            children: [
              RawMaterialButton(
                shape: CircleBorder(),
                onPressed: () {},
                child: CircleAvatar(
                  radius: _size.height / 9,
                  child: _user.account.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 100,
                        )
                      : Icon(Icons.add_a_photo),
                  backgroundImage: _user.account.photoURL != null
                      ? NetworkImage(
                          '${_user.account.photoURL}',
                        )
                      : null,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nameCtrl,
                focusNode: _nameNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  contentPadding: EdgeInsets.all(0),
                  labelText: '${'displayName'.tr()}',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontWeight: FontWeight.w700,
                  ),
                  hintText: '${_user.account.displayName}',
                  suffixIcon: _nameCtrl.text.isEmpty
                      ? IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            _nameNode.unfocus();
                            _nameNode.canRequestFocus = false;
                            pr.show(max: 100, msg: 'loading'.tr());
                            _user.account
                                .updateDisplayName('${_nameCtrl.text}');
                            AuthHandler().reload();
                            Future.delayed(Duration(seconds: 2), () {
                              pr.close();
                            });
                          },
                        ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              DetailsTile(
                legend: '${'email'.tr()}',
                value: Text('${_user.account.email}'),
                onTap: () {},
                leadingWidget: Icon(Icons.email),
              ),
              DetailsTile(
                leadingWidget: Icon(Icons.phone),
                value: Text('${_user.account.phoneNumber}'),
                legend: '${'phone'.tr()}',
                onTap: () {},
              ),
              DetailsTile(
                legend: '${'authProvider'.tr()}',
                value: Text('${_user.account.providerData[0].providerId}'),
                onTap: () {},
                leadingWidget: Icon(Icons.approval),
              ),
              DetailsTile(
                legend: '${'created'.tr()}',
                value: Text('${_user.account.metadata.creationTime}'),
                onTap: () {},
                leadingWidget: Icon(Icons.date_range),
              ),
            ],
          )),
    );
  }
}
