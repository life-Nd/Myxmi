import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/apis/ads.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/providers/recipe.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/recipe_image.dart';
import 'package:myxmi/widgets/view_selector_text.dart';
import 'creator_recipes.dart';

final InstructionsModel _instructions =
    InstructionsModel(ingredients: {}, steps: []);
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
  Map<String, dynamic> _data = {};
  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = ScrollController();
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, watch, __) {
        return Scaffold(
          body: CustomScrollView(
            controller: _ctrl,
            slivers: [
              SliverAppBar(
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
                    return Text(
                      '${widget.recipeModel.title[0].toUpperCase()}${widget.recipeModel.title.substring(1, widget.recipeModel.title.length).toLowerCase()} ',
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w700),
                    );
                  },
                ),
                flexibleSpace: Opacity(
                  opacity: 0.9,
                  child: RecipeImage(
                    height: kIsWeb ? _size.height : _size.height / 1.4,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
                expandedHeight: kIsWeb ? _size.height / 1.3 : _size.height / 2,
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
                            CreatorCard(recipe: widget.recipeModel),
                            _ViewsSelector(
                              ingredientsLength:
                                  _instructions.ingredients.length,
                              stepsLength: _instructions.steps.length,
                              reviewsLength: _instructions.reviews.length,
                            ),
                            RecipeDetails(instructions: _instructions),
                            // _AdHelper(),
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

class _AdHelper extends StatefulWidget {
  @override
  State<_AdHelper> createState() => _AdHelperState();
}

class _AdHelperState extends State<_AdHelper> {
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
  final RecipeModel recipe;
  const CreatorCard({Key key, @required this.recipe}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreatorCardState();
}

class _CreatorCardState extends State<CreatorCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      return Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          dense: false,
          title: widget.recipe?.username != null
              ? Text(widget?.recipe?.username)
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
          leading: widget?.recipe?.photoUrl != null
              ? CircleAvatar(
                  backgroundColor: Colors.amber,
                  foregroundImage: NetworkImage(widget?.recipe?.photoUrl))
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
                  uid: widget.recipe.uid,
                  name: widget?.recipe?.username,
                  avatar: widget?.recipe?.photoUrl,
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

class _ViewsSelector extends StatefulWidget {
  final int stepsLength;
  final int ingredientsLength;
  final int reviewsLength;

  const _ViewsSelector({
    Key key,
    this.stepsLength,
    this.ingredientsLength,
    this.reviewsLength,
  }) : super(key: key);

  @override
  State<_ViewsSelector> createState() => _ViewsSelectorState();
}

class _ViewsSelectorState extends State<_ViewsSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ViewSelectorText(
          length: widget.ingredientsLength ?? 0,
          viewIndex: 0,
          text: 'ingredients',
        ),
        ViewSelectorText(
          length: widget.stepsLength ?? 0,
          viewIndex: 1,
          text: 'steps',
        ),
        ViewSelectorText(
          length: widget.reviewsLength ?? 0,
          text: 'reviews',
          viewIndex: 2,
        ),
      ],
    );
  }
}
