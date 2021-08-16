import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/ads_widget.dart';
import 'recipes_stream.dart';

String _equalTo = '';

class Filtered extends StatefulWidget {
  final String legend;
  const Filtered(this.legend);
  @override
  State<StatefulWidget> createState() => _FilteredState();
}

class _FilteredState extends State<Filtered> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  final AdHelper _adHelper = AdHelper();

  @override
  void initState() {
    _equalTo = widget.legend;
    if (!kIsWeb) {
      _bannerAd = BannerAd(
        adUnitId: _adHelper.bannerAdUnitId(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.legend.tr()}s'),
      ),
      body: Column(
        children: [
          const _ExpandedRecipesStream(),
          if (!kIsWeb && _isBannerAdReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            )
        ],
      ),
    );
  }
}

class _ExpandedRecipesStream extends StatelessWidget {
  const _ExpandedRecipesStream({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RecipesStream(
        path: FirebaseFirestore.instance
            .collection('Recipes')
            .where('sub_category', isEqualTo: _equalTo)
            .snapshots(),
        // height: 100.h,
        autoCompleteField: true,
      ),
    );
  }
}
