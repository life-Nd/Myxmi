import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myxmi/apis/ads.dart';
import 'recipes_stream.dart';

String _equalTo = '';
String _where = '';

class Filtered extends StatefulWidget {
  final String legend;
  final String filter;
  const Filtered({@required this.legend, @required this.filter});
  @override
  State<StatefulWidget> createState() => _FilteredState();
}

class _FilteredState extends State<Filtered> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  final AdsApis _ads = AdsApis();

  @override
  void initState() {
    _equalTo = widget.legend;
    _where = widget.filter;
    if (!kIsWeb) {
      _bannerAd = BannerAd(
        adUnitId: _ads.filteredBannerAdUnitId(),
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
    debugPrint('_where: $_where');
    debugPrint('_equalTo: $_equalTo');
    return Expanded(
      child: RecipesStream(
        path: _equalTo != 'diet'
            ? FirebaseFirestore.instance
                .collection('Recipes')
                .where(_where, isEqualTo: _equalTo)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('Recipes')
                .orderBy('made')
                .snapshots(),
        autoCompleteField: true,
      ),
    );
  }
}
