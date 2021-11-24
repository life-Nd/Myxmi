import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({Key key}) : super(key: key);
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
            Text('Oups, ${'noInternet'.tr()}'),
            Text(
              'pleaseCheckYourInternet'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
