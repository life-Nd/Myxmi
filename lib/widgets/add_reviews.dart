import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

double _stars = 0;
TextEditingController _msgCtrl = TextEditingController();

class AddReviews extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _user = useProvider(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('${'reviewOf'.tr()} ${_recipe.details.title}'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'addScore'.tr(),
            ),
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _stars = rating;
                  print(rating);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
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
                String _dbStars = _recipe.details.stars != null
                    ? '${_recipe.details.stars}'
                    : '0.0';
                var _averageStars = (_stars + double.parse(_dbStars)) / 2;
                int _reviewsCount =
                    int.parse(_recipe?.details?.reviewsCount) + 1;
                print('$_stars + $_dbStars = $_averageStars');
                var _db = FirebaseFirestore.instance
                    .collection('Reviews')
                    .doc('${_recipe.details.recipeId}');
                _db.set(
                  {
                    '${DateTime.now().millisecondsSinceEpoch}': {
                      'message': '${_msgCtrl.text}',
                      'name': _user.account.displayName != null
                          ? '${_user.account.displayName}'
                          : '${_user.account.email}',
                      'stars': '$_stars',
                      'uid': '${_user.account.uid}',
                      'photo_url': '${_user.account.photoURL}'
                    },
                  },
                  SetOptions(merge: true),
                ).whenComplete(() {
                  FirebaseFirestore.instance
                      .collection('Recipes')
                      .doc('${_recipe.details.recipeId}')
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
