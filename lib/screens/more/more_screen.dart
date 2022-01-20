import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/auth.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';

class MoreScreen extends HookWidget {
  const MoreScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TargetPlatform _platform = Theme.of(context).platform;
    bool _onPhone = true;
    try {
      _onPhone = TargetPlatform.iOS == _platform ||
          TargetPlatform.android == _platform;
    } catch (error) {
      _onPhone = MediaQuery.of(context).size.width <= 500;
    }

    return Consumer(
      builder: (_, ref, child) {
        final _auth = ref.watch(authProvider);
        final _router = ref.watch(routerProvider);
        final _user = ref.watch(userProvider);
        return SingleChildScrollView(
          child: Column(
            children: [
              if (!kIsWeb || _onPhone)
                const ListTile(
                  title: Text(
                    'Myxmi',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                  ),
                ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text('profile'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _router.pushPage(
                    name: '/account',
                    arguments: {'uid': _user.account!.uid},
                  );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => AccountScreen(),
                  //   ),
                  // );
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text('settings'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _router.pushPage(
                    name: '/settings',
                    arguments: {'uid': _user.account!.uid},
                  );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => SettingsScreen(),
                  //   ),
                  // );
                },
              ),
              if (!kIsWeb)
                Column(
                  children: [
                    const Divider(color: Colors.grey),
                    ListTile(
                      leading: const Icon(Icons.rate_review),
                      title: Text('rateMyxmi'.tr()),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final _db = FirebaseFirestore.instance
                            .collection('App')
                            .doc('Sources')
                            .snapshots();
                        _db.listen(
                          (event) {
                            if (event.exists && event.data() != null) {
                              String? appStoreIdentifier;
                              String? googlePlayIdentifier;
                              appStoreIdentifier = event
                                  .data()!['appStoreIdentifier'] as String?;
                              googlePlayIdentifier = event
                                  .data()!['googlePlayIdentifier'] as String?;
                              final RateMyApp rateMyApp = RateMyApp(
                                minDays: 1,
                                minLaunches: 1,
                                googlePlayIdentifier: googlePlayIdentifier,
                                appStoreIdentifier: appStoreIdentifier,
                              );
                              rateMyApp.init();
                              rateMyApp.launchStore();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('error'.tr()),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.share),
                title: Text('${'inviteFriendsTo'.tr()} Myxmi'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Share.share(
                    '${'checkOutThisApp'.tr()}: \n https://Myxmi.app \n 🍸  🥗  🥘  🌯  🌮  🍰',
                    subject: 'Myxmi',
                  );
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.support),
                title: Text('support'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _router.pushPage(
                    name: '/support',
                    arguments: {'uid': _user.account?.uid},
                  );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => const SupportTicketsScreen(),
                  //   ),
                  // );
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.more_horiz),
                title: Text('about'.tr()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _router.pushPage(
                    name: '/about',
                    arguments: {},
                  );
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => AboutScreen(),
                  //   ),
                  // );
                },
              ),
              const Divider(color: Colors.grey),
              RawMaterialButton(
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.red,
                onPressed: () async {
                  await _auth.confirmSignOut(context).then(
                        (value) => _user.signedOut(),
                      );
                },
                child: Text(
                  'logout'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
