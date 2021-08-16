import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/providers/recipe.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/recipe_image.dart';
import 'package:myxmi/widgets/view_selector_text.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/ads_widget.dart';

final InstructionsModel _instructions = InstructionsModel();
final selectedRecipeView = ChangeNotifierProvider(
  (ref) => SelectedRecipeViewNotifier(),
);

class SelectedRecipe extends StatefulWidget {
  final RecipeModel recipeModel;
  const SelectedRecipe({Key key, @required this.recipeModel}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectionRecipeState();
}

class _SelectionRecipeState extends State<SelectedRecipe> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  final AdHelper _adHelper = AdHelper();
  @override
  void initState() {
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

  Map<String, dynamic> _data = {};
  @override
  Widget build(BuildContext context) {
    debugPrint('building _selectionRecipe');
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, watch, __) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Consumer(
                  builder: (context, watch, child) {
                    return Text(widget.recipeModel.title);
                  },
                ),
                flexibleSpace: RecipeImage(
                  _size.height / 1.4,
                ),
                expandedHeight: _size.height / 1.6,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Instructions')
                          .doc(widget.recipeModel.recipeId)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          debugPrint('Loading');
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('loading'.tr()),
                              const CircularProgressIndicator(),
                            ],
                          );
                        }
                        if (snapshot.hasData && snapshot.data.data() != null) {
                          final DocumentSnapshot<Map<String, dynamic>>
                              _snapshot = snapshot.data;
                          _data = _snapshot.data();
                          _instructions.fromSnapshot(snapshot: _data);
                        }
                        return Column(
                          children: [
                            Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text('${'by'.tr()}:'),
                                subtitle: const Text('Ralph N.'),
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  child: Icon(Icons.person),
                                ),
                              ),
                            ),
                            _ViewsSelector(
                              instructions: _instructions,
                            ),
                            SizedBox(
                              height: _size.height / 2,
                              child: RecipeDetails(
                                instructions: _instructions,
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
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewsSelector extends StatelessWidget {
  final InstructionsModel instructions;

  const _ViewsSelector({Key key, this.instructions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ViewSelectorText(
          length: instructions?.ingredients?.length ?? 0,
          viewIndex: 0,
          text: 'ingredients',
        ),
        ViewSelectorText(
          length: instructions?.steps?.length ?? 0,
          viewIndex: 1,
          text: 'steps',
        ),
        ViewSelectorText(
          length: instructions?.reviews?.length ?? 0,
          text: 'reviews',
          viewIndex: 2,
        ),
      ],
    );
  }
}
