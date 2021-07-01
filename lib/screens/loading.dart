// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';

// class LoadingScreen extends StatelessWidget {
//   Widget build(BuildContext context) {
//     final Size _size = MediaQuery.of(context).size;
//     return Container(
//       height: _size.height,
//       width: _size.width,
//       child: FutureBuilder(
//         future: Future.delayed(Duration(seconds: 7)),
//         builder: (_, data) {
//           return data.connectionState == ConnectionState.done
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     CircularProgressIndicator(
//                       backgroundColor: Colors.black,
//                       valueColor: AlwaysStoppedAnimation(Colors.white),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     Text('${'error'.tr()}',
//                         style: TextStyle(color: Colors.red)),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       '${'userNotRetrieved'.tr()}',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     Text('${'logOutFirst'.tr()}',
//                         style: TextStyle(color: Colors.black)),
//                   ],
//                 )
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     CircularProgressIndicator(
//                       backgroundColor: Colors.black,
//                       valueColor: AlwaysStoppedAnimation(Colors.white),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     Text('${'loading'.tr()}')
//                   ],
//                 );
//         },
//       ),
//     );
//   }
// }
