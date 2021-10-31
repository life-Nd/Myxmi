import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/widgets/details_tile.dart';
import 'package:myxmi/widgets/image_selector.dart';
import 'package:myxmi/widgets/user_avatar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../app.dart';
import '../main.dart';

final TextEditingController _nameCtrl = TextEditingController();

class AccountScreen extends HookWidget {
  final FocusNode _nameNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final Size _size = MediaQuery.of(context).size;
    final ProgressDialog pr = ProgressDialog(context: context);
    final _image = useProvider(imageProvider);
    final double _radius =
        kIsWeb && _size.width > 700 ? _size.width / 10 : _size.width / 1.5;
    return Scaffold(
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    insetPadding: const EdgeInsets.all(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Center(
                      child: Text(
                        tr('confirm'),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '${'sureYouWant'.tr()} ${'deleteYourAccount'.tr()}?'),
                        Text('everythingWillBeLost'.tr()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RawMaterialButton(
                              onPressed: () async {
                                await _user.deleteAccount();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (_) => App(),
                                    ),
                                    (route) => false);
                              },
                              fillColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${'yes'.tr()} ${'deleteMyAccount'.tr()}',
                                ),
                              ),
                            ),
                            RawMaterialButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'no'.tr(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text(
              'deleteYourAccount'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('profile'.tr()),
      ),
      body: Container(
        height: _size.height,
        width: _size.width / 1.01,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(
          padding: const EdgeInsets.all(1),
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  UserAvatar(
                    photoUrl: _user?.account?.photoURL,
                    radius: _radius,
                  ),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.deepOrange.shade300,
                    onPressed: () {},
                    child: ImageSelector(
                      onComplete: () async {
                        await _image.addImageToDb(context: context).then(
                          (url) async {
                            if (url != null) {
                              await _user.changeUserPhoto(
                                  context: context, photoUrl: url);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
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
            ),
            DetailsTile(
              legend: 'email'.tr(),
              value: Text(_user?.account?.email),
              onTap: () {},
              leadingWidget: const Icon(Icons.email),
            ),
            DetailsTile(
              leadingWidget: const Icon(Icons.phone),
              value: Text(_user?.account?.phoneNumber ?? 'noPhone'.tr()),
              legend: 'phone'.tr(),
              onTap: () {},
            ),
            DetailsTile(
              legend: 'authProvider'.tr(),
              value: Text(_user.account.providerData[0].providerId),
              onTap: () {},
              leadingWidget: const Icon(Icons.approval),
            ),
            DetailsTile(
              legend: 'created'.tr(),
              value: Text('${_user.account.metadata.creationTime}'),
              onTap: () {},
              leadingWidget: const Icon(Icons.date_range),
            ),
          ],
        ),
      ),
    );
  }
}
