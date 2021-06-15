import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'about.dart';
import 'account.dart';
import '../services/auth.dart';
import 'settings.dart';
import 'support.dart';
import 'package:rate_my_app/rate_my_app.dart';

class MoreView extends HookWidget {
  Widget build(BuildContext context) {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0, // Show rate popup on first day of install.
      minLaunches:
          5, // Show rate popup after 5 launches of app after minDays is passed.
    );
    return Container(
      child: Column(
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('${'profile'.tr()}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AccountScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('${'settings'.tr()}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('${'rateAgati'.tr()}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              rateMyApp.showRateDialog(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.support),
            title: Text('${'support'.tr()}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SupportScreen(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.more_horiz),
            title: Text('${'about'.tr()}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AboutView(),
                ),
              );
            },
          ),
          Divider(),
          RawMaterialButton(
            padding: EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            fillColor: Colors.red,
            onPressed: () => AuthHandler().confirmSignOut(context),
            child: Text(
              '${'logout'.tr()}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
