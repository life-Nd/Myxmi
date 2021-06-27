import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'recipe_tile.dart';

class RecipeList extends StatefulWidget {
  final QuerySnapshot snapshot;
  const RecipeList({@required this.snapshot});
  createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  Map _data;
  List _keys = [];
  var _builder;
  initState() {
    _data = widget.snapshot.docChanges.asMap();
    _keys = _data.keys.toList();
    _builder = ListView.builder(
      padding: EdgeInsets.all(1),
      itemCount: _keys.length,
      itemBuilder: (_, int index) {
        int _newIndex = index + 1;
        Map _indexData = widget.snapshot.docs[index].data();
        final Map _comments =
            _indexData['Comments'] != null ? _indexData['Comments'] : [];
        print("$index: $_indexData");
        final List _orderedComments = _comments.keys.toList();
        _orderedComments.sort();
        return Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Theme.of(context).cardColor,
                _indexData['Composition']['Use'] == 'Work'
                    ? Colors.yellow.shade400
                    : _indexData['Composition']['Use'] == 'Relax'
                        ? Colors.purple.shade900
                        : _indexData['Composition']['Use'] == 'Sleep'
                            ? Colors.blue.shade400
                            : Colors.grey.shade100,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _indexData['Images'].toList().isNotEmpty
                      ? Text(
                          '${_indexData['Images'].toList().isNotEmpty}'
                        )
                      : _image(_indexData['Name']),
                ),
              ),
              RecipeTile(
                indexData: _indexData,
                newIndex: _newIndex,
                keys: _keys,
                index: index,
                keyIndex: widget.snapshot.docs[index].id,
                time: '${_indexData['Made']}',
              ),
              Center(
                child: Text(
                  'comments'.tr(),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _indexData['Composition']['Use'] == 'Work'
                      ? Colors.yellow.shade600
                      : _indexData['Composition']['Use'] == 'Relax'
                          ? Colors.purple.shade400
                          : _indexData['Composition']['Use'] == 'Sleep'
                              ? Colors.blue.shade400
                              : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        _comments.isNotEmpty
                            ? Text(
                                'anonymous'.tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Container(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _comments.isNotEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(
                                      '${_comments[_orderedComments.last]}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(
                                      'noComments'.tr(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    super.initState();
  }

  Widget _image(String type) {
    switch (type) {
      case 'Fruit':
        return Image.asset(
          'assets/fruits.png',
        );
      case 'Vegetable':
        return Image.asset('assets/vegetables.png');
      case 'Meat':
        return Image.asset('assets/meat.png');
      case 'Seafood':
        return Image.asset('assets/seafood.png');
      case 'Dairy':
        return Image.asset('assets/dairy.png');
      case 'Eliquid':
        return Image.asset('assets/eliquid.png');
      default:
        return Image.asset(
          'assets/fruits.png',
          fit: BoxFit.fitWidth,
        );
    }
  }

  Widget build(BuildContext context) {
    return _builder;
  }
}
