import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/feedback.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../main.dart';
import 'about.dart';
import 'account.dart';
import 'settings.dart';

// ignore: must_be_immutable
class More extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = useProvider(authProvider);
    final _user = useProvider(userProvider);
    final _appSources = useProvider(appSources);
    bool _isPhone = true;
    try {
      _isPhone = Device.get().isPhone;
    } catch (error) {
      _isPhone = MediaQuery.of(context).size.width <= 500;
    }
    return Column(
      children: [
        if (!kIsWeb || _isPhone)
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AccountScreen(),
              ),
            );
          },
        ),
        const Divider(color: Colors.grey),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text('settings'.tr()),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SettingsScreen(),
              ),
            );
          },
        ),
        const Divider(color: Colors.grey),
        ListTile(
            leading: const Icon(Icons.support),
            title: Text('support'.tr()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FeedbackScreen(),
                ),
              );
            }),
        const Divider(color: Colors.grey),
        if (_appSources.availableForDevice && !kIsWeb && _isPhone)
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: Text('rateMyxmi'.tr()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final RateMyApp rateMyApp = RateMyApp(
                minDays: 1,
                minLaunches: 1,
                googlePlayIdentifier: _appSources.googlePlayIdentifier,
                appStoreIdentifier: _appSources.appStoreIdentifier,
              );
              rateMyApp.init();
              rateMyApp.showRateDialog(context);
            },
          ),
        ListTile(
          leading: const Icon(Icons.more_horiz),
          title: Text('about'.tr()),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AboutView(),
              ),
            );
          },
        ),
        const Divider(color: Colors.grey),
        RawMaterialButton(
          padding: const EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
    );
  }
}
