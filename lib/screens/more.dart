import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/feedback.dart';
import 'package:myxmi/utils/app_sources.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../main.dart';
import 'about.dart';
import 'account.dart';
import 'settings.dart';

// ignore: must_be_immutable
class More extends HookWidget {
  final bool _readyForRating = false;
  @override
  Widget build(BuildContext context) {
    final _auth = useProvider(authProvider);
    final _user = useProvider(userProvider);
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
        const Divider(color: Colors.grey),
        if (!kIsWeb && _isPhone)
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Feedback')
                  .doc(_user?.account?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                return ListTile(
                  leading: const Icon(Icons.rate_review),
                  title: Text('rateMyxmi'.tr()),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _readyForRating
                      ? () async {
                          final AppSources _appSources = AppSources();
                          _appSources.getAppSourcesUrls();
                          final RateMyApp rateMyApp = RateMyApp(
                            minDays: 1,
                            minLaunches: 1,
                            googlePlayIdentifier:
                                _appSources.googlePlayIdentifier,
                            appStoreIdentifier: _appSources.appStoreIdentifier,
                          );
                          rateMyApp.init();
                          rateMyApp.showRateDialog(context);
                        }
                      : () {
                          debugPrint(
                              'snapshot?.data ${snapshot?.data?.data()}');

                          // if (snapshot?.data?.data() == null) {
                          // showDialog(
                          //   context: context,
                          //   builder: (_) {
                          //     return StatefulBuilder(
                          //       builder: (_, StateSetter stateSetter) {
                          //         return AlertDialog(
                          //           title: Center(child: Text('tellMe'.tr())),
                          //           content: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Text('howIsTheExperience'.tr()),
                          //               ExperiencesSelector(
                          //                 stateSetter: stateSetter,
                          //               ),
                          //               const ExperienceTextfield(),
                          //             ],
                          //           ),
                          //           actions: [
                          //             RawMaterialButton(
                          //               shape: RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.circular(10)),
                          //               onPressed: _experience != null
                          //                   ? () {
                          //                       Navigator.of(context).pop();
                          //                       sendFeedback(
                          //                         email:
                          //                             _user?.account?.email,
                          //                         uid: _user?.account?.uid,
                          //                         experience: _experience,
                          //                         message: _ctrl.text,
                          //                         name: _user
                          //                             ?.account?.displayName,
                          //                       );
                          //                       _ctrl.clear();
                          //                     }
                          //                   : () {},
                          //               fillColor: _experience != null
                          //                   ? Colors.green
                          //                   : null,
                          //               child: Text('send'.tr()),
                          //             ),
                          //             RawMaterialButton(
                          //               shape: RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.circular(10)),
                          //               fillColor: _experience == null
                          //                   ? Colors.red
                          //                   : null,
                          //               child: Text(
                          //                 'cancel'.tr(),
                          //                 style: TextStyle(
                          //                     color: _experience == null
                          //                         ? Colors.white
                          //                         : Colors.red),
                          //               ),
                          //               onPressed: () {
                          //                 Navigator.of(context).pop();
                          //               },
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     );
                          //   },
                          // );
                          // } else {
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FeedbackScreen(
                                    // snapshotData: snapshot.data.data()
                                    //     as Map<String, dynamic>,
                                    ),
                              ),
                            );
                          }
                        },
                );
              }),
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
    );
  }
}
