import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'error'.tr(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset('assets/no_internet.png'),
            ),
            Expanded(
              child: ListTile(
                title: Text('Oups, ${'noInternet'.tr()}'),
                subtitle: Text(
                  'pleaseCheckYourInternet'.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
