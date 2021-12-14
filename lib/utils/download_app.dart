import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/utils/launch_url.dart';

// ignore: must_be_immutable
class DownloadApp extends StatelessWidget {
  Map? _data = {};
  String? googlePlayUrl = 'https://play.google.com/store';
  // android: https://play.google.com/store
  String? appstoreUrl = 'https://www.apple.com/ca/app-store/';
  // IOS : https://www.apple.com/ca/app-store/
  String? appStoreIdentifier;
  String? googlePlayIdentifier;
  // bool availableForDevice = false;

  Stream<DocumentSnapshot<Map>> stream() {
    final _db = FirebaseFirestore.instance;
    return _db.collection('Sources').doc('AppStores').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 7),
        Text(
          'bestExperience'.tr(),
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        StreamBuilder<DocumentSnapshot<Map>>(
          stream: stream(),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map>> snapshot) {
            if (snapshot.hasData) {
              _data = snapshot.data!.data();
              googlePlayUrl = _data!['googlePlayUrl'] as String?;
              appstoreUrl = _data!['appstoreUrl'] as String?;
              appStoreIdentifier = _data!['appStoreIdentifier'] as String?;
              googlePlayIdentifier = _data!['googlePlayIdentifier'] as String?;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Theme.of(context).cardColor,
                  onPressed: () {
                    launchURL(url: googlePlayUrl!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/playstore.png',
                            height: 77,
                            width: 77,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text('downloadAndroidApp'.tr())
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Theme.of(context).cardColor,
                  onPressed: () {
                    launchURL(url: appstoreUrl!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/appstore.png',
                            color: Colors.white,
                            height: 77,
                            width: 77,
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
            );
          },
        ),
      ],
    );
  }
}
