// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:myxmi/screens/home.dart';
// import '../main.dart';
// import 'support.dart';

// final TextEditingController _titleCtrl = TextEditingController();
// final TextEditingController _messageCtrl = TextEditingController();

// class AskSupport extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 20,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomRight: Radius.circular(20),
//             bottomLeft: Radius.circular(20),
//           ),
//         ),
//         title: ListTile(
//           minLeadingWidth: 40,
//           leading: const Icon(
//             Icons.help_rounded,
//             color: Colors.green,
//             size: 40,
//           ),
//           dense: true,
//           title: Text('support'.tr()),
//           subtitle: Text('connected'.tr()),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ListTile(
//               title: Text('${'urQuestion?'.tr()} ?'),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 2),
//               child: TextField(
//                 controller: _titleCtrl,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'enterShortTitle'.tr(),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _messageCtrl,
//                 maxLines: 20,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'enterMessage'.tr(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       extendBody: true,
//       bottomNavigationBar: Consumer(builder: (_, watch, __) {
//         final _user = watch(userProvider);
//         final _prefs = watch(prefProvider);
//         final _view = watch(viewProvider);
//         return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _view.loading
//                 ? Container(
//                     width: 40,
//                     height: 40,
//                     alignment: Alignment.bottomCenter,
//                     child: const CircularProgressIndicator(color: Colors.blue))
//                 : RawMaterialButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     fillColor: Colors.blue,
//                     onPressed: () {
//                       debugPrint('NOTEMPTY:_titleCtrl.text:${_titleCtrl.text}');
//                       debugPrint(
//                           'NOTEMPTY:_messageCtrl.text:${_messageCtrl.text}');
//                       if (_titleCtrl.text.isNotEmpty &&
//                           _messageCtrl.text.isNotEmpty) {
//                         _view.loadingEntry(isLoading: true);

//                         final int _now = DateTime.now().millisecondsSinceEpoch;
//                         FirebaseFirestore.instance.collection('Support').add(
//                           {
//                             'by': _user.account.uid,
//                             'message': _messageCtrl.text,
//                             'title': _titleCtrl.text,
//                             'answered': false,
//                             'time': '$_now',
//                             'name': _user.account.displayName,
//                             'email': _user.account.email,
//                             'avatar': _user.account.photoURL,
//                             'language': _prefs.language,
//                             'messagesCount': '0'
//                           },
//                         ).then(
//                           (value) {
//                             debugPrint('value: ${value.id}');
//                             _titleCtrl.clear();
//                             _messageCtrl.clear();
//                             showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (_) => AlertDialog(
//                                 insetPadding: const EdgeInsets.all(1),
//                                 contentPadding: const EdgeInsets.all(1),
//                                 title: const Icon(
//                                   Icons.check_circle_outline,
//                                   size: 50,
//                                   color: Colors.green,
//                                 ),
//                                 content: ListTile(
//                                   title: Text('messageSent'.tr()),
//                                   subtitle: Text(
//                                     '${'answerWithin'.tr()} ${'hours'.tr()}',
//                                   ),
//                                 ),
//                                 actions: [
//                                   RawMaterialButton(
//                                     onPressed: () {
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                           builder: (_) => SupportScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       'close'.tr(),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       }
//                     },
//                     child: Text('ask'.tr()),
//                   ));
//       }),
//     );
//   }
// }
