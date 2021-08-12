import 'dart:io';

import 'package:myxmi/apis/ad_apis.dart';

// "ca-app-pub-2388296417113372~7420390794"/>

class AdHelper {
  final AdApis _adApis = AdApis();
  String bannerAdUnitId() {
    if (Platform.isAndroid) {
      return _adApis.androidAppId;
      // _adsApis.androidRecipesPageUnitId;
    } else if (Platform.isIOS) {
      return _adApis.iosRecipesPageUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  String interstitialAdUnitId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String rewardedAdUnitId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
