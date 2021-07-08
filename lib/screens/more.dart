import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../services/auth.dart';
import 'about.dart';
import 'account.dart';
import 'home.dart';
import 'settings.dart';
import 'support.dart';

class MoreView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _view = useProvider(viewProvider);
    final RateMyApp rateMyApp = RateMyApp(
      minDays: 0, // Show rate popup on first day of install.
      minLaunches:
          5, // Show rate popup after 5 launches of app after minDays is passed.
    );
    return Column(
      children: [
       const Divider(),
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
       const Divider(),
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
       const Divider(),
        ListTile(
          leading: const Icon(Icons.rate_review),
          title: Text('rateMyxmi'.tr()),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            rateMyApp.showRateDialog(context);
          },
        ),
       const Divider(),
        ListTile(
          leading: const Icon(Icons.support),
          title: Text('support'.tr()),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SupportScreen(),
            ));
          },
        ),
       const Divider(),
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
      const Divider(),
        RawMaterialButton(
          padding: const EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          fillColor: Colors.red,
          onPressed: () {
            _view.view = 0;
            AuthHandler().confirmSignOut(context);
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
