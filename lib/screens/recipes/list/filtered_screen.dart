import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/screens/home/widgets/body.dart';
import 'package:myxmi/streams/recipes.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:myxmi/apis/ads.dart';

class FilteredScreen extends StatefulWidget {
  final String type;

  const FilteredScreen({required this.type});
  @override
  State<StatefulWidget> createState() => _FilteredState();
}

class _FilteredState extends State<FilteredScreen> {
  // BannerAd _bannerAd;
  // bool _isBannerAdReady = false;
  // final AdsApis _ads = AdsApis();

  @override
  void initState() {
    // _equalTo = widget.legend;
    // _where = widget.filter;
    // if (!kIsWeb) {
    //   _bannerAd = BannerAd(
    //     adUnitId: _ads.filteredBannerAdUnitId(),
    //     request: const AdRequest(),
    //     size: AdSize.banner,
    //     listener: BannerAdListener(
    //       onAdLoaded: (_) {
    //         setState(() {
    //           _isBannerAdReady = true;
    //         },);
    //       },
    //       onAdFailedToLoad: (ad, err) {
    //         debugPrint('Failed to load a banner ad: ${err.message}');
    //         _isBannerAdReady = false;
    //         ad.dispose();
    //       },
    //     ),
    //   );
    //   _bannerAd.load();
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.tr()),
      ),
      body: Column(
        children: [
          _ExpandedRecipesStream(type: widget.type),
          // if (!kIsWeb && _isBannerAdReady)
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: SizedBox(
          //     width: _bannerAd.size.width.toDouble(),
          //     height: _bannerAd.size.height.toDouble(),
          //     child: AdWidget(ad: _bannerAd),
          //   ),
          // )
        ],
      ),
    );
  }
}

class _ExpandedRecipesStream extends StatelessWidget {
  final String type;
  const _ExpandedRecipesStream({Key? key, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == 'myRecipes') {
      return const Expanded(
        child: RecipesByUid(),
      );
    }
    if (type == 'favoritesRecipes') {
      return const Expanded(
        child: RecipesUidLiked(),
      );
    }
    if (type != 'anyDiet') {
      debugPrint('type: $type');
      return Expanded(
        child: RecipesStreamBuilder(
          showAutoCompleteField: true,
          snapshots: FirebaseFirestore.instance
              .collection('Recipes')
              .where('tags.$type', isEqualTo: true)
              .snapshots(),
        ),
      );
    } else {
      return Expanded(
        child: RecipesStreamBuilder(
          snapshots: FirebaseFirestore.instance
              .collection('Recipes')
              .orderBy('made')
              .snapshots(),
          showAutoCompleteField: true,
        ),
      );
    }
  }
}
