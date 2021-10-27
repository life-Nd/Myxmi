import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/apis/ads.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/creator_recipes.dart';

class AdLoader extends StatefulWidget {
  @override
  State<AdLoader> createState() => _AdLoaderState();
}

class _AdLoaderState extends State<AdLoader> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  final AdsApis _ads = AdsApis();
  @override
  void initState() {
    if (!kIsWeb) {
      _bannerAd = BannerAd(
        adUnitId: _ads.selectedRecipeBannerAdUnitId(),
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isBannerAdReady = true;
            });
          },
          onAdFailedToLoad: (ad, err) {
            debugPrint('Failed to load a banner ad: ${err.message}');
            _isBannerAdReady = false;
            ad.dispose();
          },
        ),
      );
      _bannerAd.load();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: !kIsWeb && _isBannerAdReady
          ? SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd))
          : const CircularProgressIndicator(),
    );
  }
}

// ignore: must_be_immutable
class CreatorCard extends StatefulWidget {
  // final RecipeModel recipe;
  const CreatorCard({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreatorCardState();
}

class _CreatorCardState extends State<CreatorCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _recipe = watch(recipeProvider).recipeModel;
      return Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          dense: false,
          title: _recipe?.username != null
              ? Text(_recipe?.username)
              : Text('noName'.tr()),
          // subtitle: Row(
          //   children: [
          //     const Text(
          //       '0 ',
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          //     ),
          //     Text(
          //       'followers'.tr(),
          //     ),
          //   ],
          // ),
          leading: _recipe?.photoUrl != null
              ? CircleAvatar(
                  backgroundColor: Colors.amber,
                  foregroundImage: NetworkImage(_recipe?.photoUrl),
                )
              : const Icon(Icons.person),
          // trailing: 'a' == 'a'
          //     ? InkWell(
          //         onTap: () {},
          //         child: Text(
          //           'follow'.tr(),
          //           style: TextStyle(
          //               color: Theme.of(context).scaffoldBackgroundColor,
          //               fontSize: 19,
          //               fontWeight: FontWeight.w400),
          //         ),
          //       )
          //     : InkWell(
          //         onTap: () {},
          //         child: Text(
          //           'following'.tr(),
          //           style: const TextStyle(color: Colors.green),
          //         ),
          //       ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CreatorRecipes(
                  uid: _recipe.uid,
                  name: _recipe?.username,
                  avatar: _recipe?.photoUrl,
                  followersCount: '${Random().nextInt(777)}',
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
