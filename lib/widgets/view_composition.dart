import 'package:myxmi/provider/favorites.dart';
import 'package:myxmi/provider/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'change_score.dart';

// Ajouter champ procedure.
// Pour detailler la succession, temps de melange.

Future<dynamic> viewComposition(
    {BuildContext context,
    @required UserProvider user,
    @required FavoritesProvider fav,
    @required Size size,
    @required Map indexData,
    @required String keyIndex}) {
  int _newIndex = 0;

  Map _composition = indexData['Composition'];
  List _compositionKeys = _composition.keys.toList();

  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        buttonPadding: EdgeInsets.all(0),
        titlePadding: EdgeInsets.all(1),
        contentPadding: EdgeInsets.all(0),
        insetPadding: EdgeInsets.all(0),
        actionsPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // TITLE WITH LEADING ICON OF BOTTOMNAVBAR
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).cardColor,
                _composition['Use'] == 'Work'
                    ? Colors.yellow.shade700
                    : _composition['Use'] == 'Relax'
                        ? Colors.purple.shade900
                        : _composition['Use'] == 'Sleep'
                            ? Colors.blue.shade900
                            : Colors.grey.shade700,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(builder: (context, StateSetter setState) {
                int _length = indexData['Images'] != null
                    ? indexData['Images']?.toList()?.length
                    : 0;
                return Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      width: size.width / 1,
                      height: size.height / 3,
                      child: PageView.builder(
                        onPageChanged: (index) {
                          _newIndex = index;
                          setState(() {});
                        },
                        itemCount: _length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${indexData['Images'].toList()[index]}',
                              width: size.width / 1,
                              height: size.height / 3,
                              cacheHeight: 10000,
                              cacheWidth: 10000,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${indexData['Name']} #${indexData['Reference']}'),
                          GestureDetector(
                              child: CircleAvatar(
                                backgroundColor:
                                    double.parse('${indexData['Score']}') < 5.0
                                        ? Colors.red
                                        : Colors.green,
                                child: Text(
                                  '${indexData['Score']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {
                                changeScore(
                                    context: context, keyIndex: keyIndex);
                              }),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              user.account?.uid == null
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.star_border,
                                      ),
                                      onPressed: () {},
                                    )
                                  : !fav.favorites.keys.contains(keyIndex)
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.star_border,
                                            size: 40,
                                          ),
                                          onPressed: () {
                                            Map<String, dynamic> _data = {};
                                            _data[keyIndex] = {
                                              'Name': '${indexData['Name']}',
                                              'UserName':
                                                  '${indexData['UserName']}',
                                              'Liked':
                                                  '${DateTime.now().millisecondsSinceEpoch}',
                                              'Composition':
                                                  indexData['Composition'],
                                            };
                                            FirebaseFirestore.instance
                                                .collection('Favorites')
                                                .doc('${user.account.uid}')
                                                .set(_data,
                                                    SetOptions(merge: true));
                                            fav.addFavorites(
                                                newFavorite: _data);
                                            setState(() {});
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
                                                .doc('${user.account.uid}')
                                                .update({
                                              '$keyIndex': FieldValue.delete()
                                            });
                                            fav.removeFavorites(
                                                newFavorite: keyIndex);
                                            setState(() {});
                                          },
                                        ),
                              _length > 0
                                  ? Text('${_newIndex + 1}/$_length')
                                  : Text('0 images')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              Container(
                height: size.height / 3,
                width: size.width / 1,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ListView.builder(
                      itemCount: _compositionKeys.length,
                      itemBuilder: (_, int index) {
                        String _keyIndex = _compositionKeys[index];
                        return ListTile(
                          title: Text('$_keyIndex'),
                          subtitle: Text('${_composition[_keyIndex]}'),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${'actQuantity'.tr()}: '),
                              Text(
                                '${indexData['Actual Quantity']} g',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${'estQuantity'.tr()}: '),
                              Text(
                                '${indexData['Estimated Quantity']}',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(' g'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
