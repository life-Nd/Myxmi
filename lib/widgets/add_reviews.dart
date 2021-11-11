import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/main.dart';
import 'recipe_details.dart';

double _stars = 0;
final TextEditingController _msgCtrl = TextEditingController();

class AddReviews extends StatelessWidget {
  const AddReviews({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeDetailsProvider);
      final _user = watch(userProvider);
      final String _title = _recipe.recipe.title;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            ' $_title',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
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
              TextField(
                // controller: ,
                decoration: InputDecoration(
                  isDense: false,
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                maxLines: 10,
              ),
              RawMaterialButton(
                fillColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  final String _now =
                      '${DateTime.now().millisecondsSinceEpoch}';
                  final String _dbStars = _recipe.recipe.stars ?? '0.0';
                  final _averageStars = (_stars + double.parse(_dbStars)) / 2;
                  final int _commentsCount =
                      _recipe?.recipe?.commentsCount != null
                          ? int.parse(_recipe?.recipe?.commentsCount) + 1
                          : 1;
                  debugPrint('$_stars + $_dbStars = $_averageStars');
                  final _db = FirebaseFirestore.instance
                      .collection('Comments')
                      .doc(_recipe.recipe.recipeId);
                  _db.set(
                    {
                      _now: {
                        'message': _msgCtrl.text,
                        'name':
                            _user.account.displayName ?? _user.account.email,
                        'stars': '$_stars',
                        'uid': _user.account.uid,
                        'photo_url': _user.account.photoURL
                      },
                    },
                    SetOptions(merge: true),
                  ).whenComplete(() {
                    debugPrint(
                        '--FIREBASE-- Writing: Comments/${_recipe.recipe.recipeId}/$_now ');
                    FirebaseFirestore.instance
                        .collection('Recipes')
                        .doc(_recipe.recipe.recipeId)
                        .update({
                      'stars': '$_averageStars',
                      'comments_count': '$_commentsCount',
                    });
                    _recipe.recipe.stars = '$_averageStars';
                    _msgCtrl.clear();
                    _stars = 0.0;
                    debugPrint(
                        '--FIREBASE-- Writing: Recipes/${_recipe.recipe.recipeId} stars & comments_count ');
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
    });
  }
}
