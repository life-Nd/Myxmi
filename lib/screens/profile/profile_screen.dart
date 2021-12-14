import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/profile/widgets/delete_account.dart';
import 'package:myxmi/screens/profile/widgets/details_tile.dart';
import 'package:myxmi/screens/profile/widgets/display_name_field.dart';
import 'package:myxmi/screens/profile/widgets/user_profile_picture.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        return Scaffold(
          bottomSheet: const DeleteAccount(),
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
                const UserProfilePicture(),
                const SizedBox(
                  height: 10,
                ),
                DisplayNameField(),
                DetailsTile(
                  legend: 'email'.tr(),
                  value: Text(_user.account!.email!),
                  onTap: () {},
                  leadingWidget: const Icon(Icons.email),
                ),
                DetailsTile(
                  leadingWidget: const Icon(Icons.phone),
                  value: Text(_user.account!.phoneNumber ?? 'noPhone'.tr()),
                  legend: 'phone'.tr(),
                  onTap: () {},
                ),
                DetailsTile(
                  legend: 'authProvider'.tr(),
                  value: Text(_user.account!.providerData[0].providerId),
                  onTap: () {},
                  leadingWidget: const Icon(Icons.approval),
                ),
                DetailsTile(
                  legend: 'created'.tr(),
                  value: Text('${_user.account!.metadata.creationTime}'),
                  onTap: () {},
                  leadingWidget: const Icon(Icons.date_range),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
