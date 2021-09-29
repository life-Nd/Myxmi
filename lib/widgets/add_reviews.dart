import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';

double _stars = 0;
TextEditingController _msgCtrl = TextEditingController();

class AddReviews extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _user = useProvider(userProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('${'reviewOf'.tr()} ${_recipe.recipeModel.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'addScore'.tr(),
            ),
            Center(
              child: RatingBar.builder(
                minRating: 1,
                allowHalfRating: true,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _stars = rating;
                  debugPrint('$rating');
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _msgCtrl,
                decoration: InputDecoration(
                  isDense: false,
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                maxLines: 10,
              ),
            ),
            RawMaterialButton(
              fillColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                final String _dbStars = _recipe.recipeModel.stars ?? '0.0';
                final _averageStars = (_stars + double.parse(_dbStars)) / 2;
                final int _reviewsCount =
                    int.parse(_recipe?.recipeModel?.reviewsCount) + 1;
                debugPrint('$_stars + $_dbStars = $_averageStars');
                final _db = FirebaseFirestore.instance
                    .collection('Reviews')
                    .doc(_recipe.recipeModel.recipeId);
                _db.set(
                  {
                    '${DateTime.now().millisecondsSinceEpoch}': {
                      'message': _msgCtrl.text,
                      'name': _user.account.displayName ?? _user.account.email,
                      'stars': '$_stars',
                      'uid': _user.account.uid,
                      'photo_url': _user.account.photoURL
                    },
                  },
                  SetOptions(merge: true),
                ).whenComplete(() {
                  FirebaseFirestore.instance
                      .collection('Recipes')
                      .doc(_recipe.recipeModel.recipeId)
                      .update({
                    'stars': '$_averageStars',
                    'reviews_count': '$_reviewsCount',
                  });
                  _msgCtrl.clear();
                  _stars = 0.0;

                  Navigator.of(context).pop();
                });
              },
              child: Text(
                'save'.tr(),
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
