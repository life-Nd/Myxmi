import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/apis/ads.dart';
import 'package:myxmi/main.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  final AdsApis _ads = AdsApis();

  @override
  void initState() {
    if (!kIsWeb) {
      _bannerAd = BannerAd(
        adUnitId: _ads.cartBannerAdUnitId(),
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
        title: Text('cart'.tr()),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (_, watch, child) {
                final _prefs = watch(cartProvider);
                if (_prefs.cart != null && _prefs.cart.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _prefs.cart.length,
                    itemBuilder: (_, int index) {
                      return ListTile(
                        leading: IconButton(
                          icon: _prefs.checkedItem.contains(_prefs.cart[index])
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.radio_button_unchecked),
                          onPressed: () async {
                            await _prefs.editItems(item: _prefs.cart[index]);
                          },
                        ),
                        title: Text(_prefs.cart[index].toUpperCase()),
                      );
                    },
                  );
                }
                return Center(
                  child: Text(
                    'cartEmpty'.tr(),
                  ),
                );
              },
            ),
          ),
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
