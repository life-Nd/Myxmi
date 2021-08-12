import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'ads_widget.dart';
import 'recipes_stream.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.legend.tr()}s'),
      ),
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          RecipesStream(
            path: FirebaseFirestore.instance
                .collection('Recipes')
                .where('sub_category', isEqualTo: widget.legend)
                .snapshots(),
                height: 70.h - _bannerAd.size.height,
            autoCompleteField: true,
          ),
          if (_isBannerAdReady)
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
