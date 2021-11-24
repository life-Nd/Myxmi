import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:url_launcher/url_launcher.dart';

class AppNetworkProvider {
  Map _data = {};
  String googlePlayUrl;
  // android: https://play.google.com/store
  String appstoreUrl;
  // IOS : https://www.apple.com/ca/app-store/
  String appStoreIdentifier;
  String googlePlayIdentifier;
  bool availableForDevice = false;

  void getAppNetwork(BuildContext context) {
    final _db = FirebaseFirestore.instance;
    _db
        .collection('Sources')
        .doc('AppStores')
        .snapshots()
        .listen((DocumentSnapshot<Map> event) {
      if (event.exists) {
        _data = event.data();
        googlePlayUrl = _data['googlePlayUrl'] as String;
        appstoreUrl = _data['appStoreUrl'] as String;
        googlePlayIdentifier = _data['googlePlayIdentifier'] as String;
        appStoreIdentifier = _data['appStoreIdentifier'] as String;
      }
    });
    if (kIsWeb) {
      debugPrint('kIsWeb: $kIsWeb');
      try {
        if (Device.get().isPhone) {
          debugPrint('--Mobile Web started--');
          availableForDevice =
              Device.get().isIos ? appstoreUrl != null : googlePlayUrl != null;
          downloadAppDialog(context);
        } else {
          debugPrint('--Browser Web started--');
        }
      } catch (error) {
        debugPrint('--App started--');
      }
    }
  }

  void downloadAppDialog(BuildContext context) {
    if (_data != null) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(
              child: Text(
                'tryOurApp'.tr(),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('aBetterExperience'.tr()),
                Row(
                  children: [
                    Text('downloadAppOn'.tr()),
                    if (Device.get().isAndroid)
                      const Text('Playstore')
                    else
                      const Text('AppStore')
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Device.get().isAndroid
                          ? Colors.green.shade400
                          : Colors.grey,
                      onPressed: () {
                        if (Device.get().isAndroid) {
                          launchURL(url: googlePlayUrl);
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/playstore.png',
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text('downloadAndroidApp'.tr())
                            ],
                          )),
                    ),
                    const SizedBox(height: 10),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Device.get().isIos
                          ? Colors.green.shade400
                          : Colors.grey,
                      onPressed: () {
                        launchURL(url: appstoreUrl);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/appstore.png',
                                height: 40,
                                width: 40,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text('downloadIosApp'.tr())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              RawMaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.red,
                onPressed: () {
                  // _home.showDownloadDialog = false;
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('close'.tr()),
                ),
              )
            ],
          );
        },
      );
    }
  }

  // ignore: avoid_void_async
  void launchURL({String url}) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
