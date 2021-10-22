import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/apis/ads.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/providers/recipe.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/recipe_image.dart';
import 'add_recipe_infos.dart';
import 'creator_recipes.dart';

final InstructionsModel _instructions =
    InstructionsModel(ingredients: {}, steps: []);
final selectedRecipeView = ChangeNotifierProvider(
  (ref) => SelectedRecipeViewNotifier(),
);

class SelectedRecipe extends StatefulWidget {
  static const String route = '/recipe';
  const SelectedRecipe({Key key}) : super(key: key);
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
        final _recipe = watch(recipeProvider);
        return Scaffold(
          body: CustomScrollView(
            controller: _ctrl,
            slivers: [
              SliverAppBar(
                leadingWidth: 30,
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
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${_recipe.recipeModel.title[0].toUpperCase()}${_recipe.recipeModel.title.substring(1, _recipe.recipeModel.title.length).toLowerCase()} ',
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                    );
                  },
                ),
                flexibleSpace: Opacity(
                  opacity: 0.9,
                  child: RecipeImage(
                    height: kIsWeb ? _size.height : _size.height / 2.5,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
                expandedHeight:
                    kIsWeb ? _size.height / 1.3 : _size.height / 2.5,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Instructions')
                          .doc(_recipe.recipeModel.recipeId)
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
                            const CreatorCard(),
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
                  foregroundImage: NetworkImage(_recipe?.photoUrl))
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
