// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:myxmi/providers/user.dart';
// import 'package:myxmi/providers/view.dart';

// import 'search.dart';

// class PhoneAppBar extends StatelessWidget implements PreferredSizeWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   PhoneAppBar({Key key, this.viewIndex, this.view, this.user})
//       : preferredSize = const Size.fromHeight(60.0),
//         super(key: key);

//   @override
//   final Size preferredSize;
//   final int viewIndex;
//   final ViewProvider view;
//   final UserProvider user;

//   @override
//   Widget build(BuildContext context) {
//     return PreferredSize(
//       preferredSize: preferredSize,
//       child: PreferredSize(
//         preferredSize: viewIndex == 0 && view.searching ||
//                 viewIndex == 1 && user.account?.uid != null && view.searching
//             ? kIsWeb
//                 ? Size(preferredSize.width, 150)
//                 : Size(preferredSize.width, 100)
//             : Size(preferredSize.width, 55),
//         child: SafeArea(
//           child: Column(
//             children: [
//               if (kIsWeb)
//                 SearchRecipes(
//                   showFilter: viewIndex == 2 && user.account?.uid != null,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
