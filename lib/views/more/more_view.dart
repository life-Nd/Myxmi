import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/views/support/support_view.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import '../../main.dart';
import '../account/account_view.dart';
import '../more/settings/view.dart';
import 'about/view.dart';

// ignore: must_be_immutable
class More extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = useProvider(authProvider);
    final _user = useProvider(userProvider);
    final _appSources = useProvider(appNetworkProvider);
    bool _isPhone = true;
    try {
      _isPhone = Device.get().isPhone;
    } catch (error) {
      _isPhone = MediaQuery.of(context).size.width <= 500;
    }

    return SingleChildScrollView(
      child: Column(
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
                  builder: (_) => AccountView(),
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
                  builder: (_) => SettingsView(),
                ),
              );
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
                  subject: 'Myxmi');
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
                  builder: (_) => SupportTicketsView(),
                ),
              );
            },
          ),
          const Divider(color: Colors.grey),
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
      ),
    );
  }
}
