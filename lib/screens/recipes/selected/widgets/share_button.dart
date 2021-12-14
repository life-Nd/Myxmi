import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/home/home_screen.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String? recipeId;

  const ShareButton({Key? key, required this.recipeId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        final _uid = _user.account?.uid;
        final _router = ref.watch(routerProvider);
        final _view = ref.watch(homeScreenProvider);
        return InkWell(
          onTap: _uid != null
              ? () {
                  Share.share(
                    '${'checkOutThisRecipe'.tr()}:😍😍😍 \n https://myxmi.app/recipe?id=$recipeId \n',
                  );
                }
              : () {
                  _view.changeView(index: 5);
                  _router.pushPage(name: '/home');
                },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.share,
              color: Colors.black,
              size: 25,
            ),
          ),
        );
      },
    );
  }
}
