import 'package:myxmi/utils/update_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/details_tile.dart';
import '../main.dart';

class AccountScreen extends HookWidget {
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${'more'.tr()}'),
      ),
      body: Container(
          height: _size.height / 1.5,
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
              DetailsTile(
                leadingWidget: Icon(Icons.person),
                legend: '${'displayName'.tr()}',
                value: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_user.account.displayName}',
                    ),
                    Icon(Icons.edit),
                  ],
                ),
                onTap: () {
                  updateName(
                      context: context, displayName: _user.account.displayName);
                },
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
