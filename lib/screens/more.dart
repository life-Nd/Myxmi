import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/app_sources.dart';
import 'package:rate_my_app/rate_my_app.dart';

// import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../utils/auth.dart';
import 'about.dart';
import 'account.dart';
import 'home.dart';
import 'settings.dart';

class More extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // final ProgressDialog pr = ProgressDialog(context: context);
    final _view = useProvider(homeViewProvider);
    bool _isPhone = true;
    try {
      _isPhone = Device.get().isPhone;
      debugPrint('try: $_isPhone');
    } catch (error) {
      debugPrint('error: $_isPhone');
      debugPrint('width: ${MediaQuery.of(context).size.width}');
      _isPhone = MediaQuery.of(context).size.width <= 500;
      debugPrint('error2: $_isPhone');
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
        // const Divider(),
        // ListTile(
        //   leading: const Icon(Icons.support),
        //   title: Text('support'.tr()),
        //   trailing: const Icon(Icons.arrow_forward_ios),
        //   onTap: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (_) => SupportScreen(),
        //     ));
        //   },
        // ),
        const Divider(),
        if (!kIsWeb && _isPhone)
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: Text('rateMyxmi'.tr()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final AppSources _appSources = AppSources();
              _appSources.downloadAppDialog(context);
              final RateMyApp rateMyApp = RateMyApp(
                minDays: 1,
                minLaunches: 1,
                googlePlayIdentifier: _appSources.googlePlayIdentifier,
                appStoreIdentifier: _appSources.appStoreIdentifier,
              );
              rateMyApp.init();
              rateMyApp.showRateDialog(
                context,
                // listener: (RateMyAppDialogButton status) {
                //   debugPrint('status.index: ${status.index}');
                //   return true;
                // },
              );
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
            AuthServices().confirmSignOut(context);
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
