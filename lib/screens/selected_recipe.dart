import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/app.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart';

class SelectedRecipe extends HookWidget {
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _details = _recipe.details;
    final _user = useProvider(userProvider);
    final _fav = useProvider(favProvider);
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_recipe.details.title}'),
      ),
      body: Container(
        height: _size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor,
              _details.difficulty == 'easy'
                  ? Colors.yellow.shade700
                  : _details.difficulty == 'medium'
                      ? Colors.orange.shade900
                      : _details.difficulty == 'hard'
                          ? Colors.red.shade700
                          : Colors.grey.shade700,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: _size.width / 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      '${_details.imageUrl}',
                      width: _size.width / 1,
                      height: _size.height / 3,
                      cacheHeight: 10000,
                      cacheWidth: 10000,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_details.title} #${_details.reference}'),
                      GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              '${_details.stars}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            // changeScore(context: context, keyIndex: keyIndex);
                          }),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _user.account?.uid == null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.star_border,
                                  ),
                                  onPressed: () {},
                                )
                              : !_fav.favorites.keys.contains(_details.recipeId)
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.star_border,
                                        color: Colors.yellow,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        print('DETAILS ${_details.recipeId}');
                                        Map<String, dynamic> _data = {};
                                        print('DETAILS: ${_details.recipeId}');
                                        _data[_details.recipeId] = {
                                          'UserName':
                                              '${_user.account.displayName}',
                                          'Liked':
                                              '${DateTime.now().millisecondsSinceEpoch}',
                                        };
                                        FirebaseFirestore.instance
                                            .collection('Favorites')
                                            .doc('${_user.account.uid}')
                                            .set(
                                                _data, SetOptions(merge: true));
                                        _fav.addFavorites(newFavorite: _data);
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.star_outlined,
                                        size: 40,
                                        color: Colors.yellowAccent,
                                      ),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Favorites')
                                            .doc('${_user.account.uid}')
                                            .update({
                                          '${_details.recipeId}':
                                              FieldValue.delete()
                                        });
                                        _fav.removeFavorites(
                                            newFavorite: _details.recipeId);
                                      },
                                    ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Instructions')
                    .doc('${_details.recipeId}')
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('${'error'}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text('${'loading'.tr()}...'),
                    );
                  }
                  if (snapshot.hasData) {
                    print('SNAPSHOT: ${snapshot.data.data()}');
                    Map _data = snapshot.data.data();
                    List _steps = _data['steps'];
                    Map _products = _data['products'];
                    List _productsKeys = _products.keys.toList();
                    return Container(
                      height: _size.height / 1.9,
                      child: PageView(
                        children: [
                          Column(
                            children: [
                              Text(
                                'ingredients'.tr().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Container(
                                height: _size.height / 2.1,
                                width: _size.width / 1,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ListView.builder(
                                      itemCount: _productsKeys.length,
                                      itemBuilder: (_, int index) {
                                        return ListTile(
                                          leading: IconButton(
                                            icon: Icon(
                                                Icons.radio_button_unchecked),
                                            onPressed: () {},
                                          ),
                                          title: Row(
                                            children: [
                                              Text(
                                                '${_productsKeys[index]}: ',
                                              ),
                                              Text(
                                                '${_products[_productsKeys[index]]}',
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'instructions'.tr().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Container(
                                height: _size.height / 2.1,
                                width: _size.width / 1,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ListView.builder(
                                      itemCount: _steps.length,
                                      itemBuilder: (_, int index) {
                                        return ListTile(
                                          leading: IconButton(
                                            icon: Icon(
                                                Icons.radio_button_unchecked),
                                            onPressed: () {},
                                          ),
                                          title: Text(
                                            '${_steps[index]}',
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'instructionsEmpty'.tr(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
