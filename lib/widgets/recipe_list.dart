import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'recipe_tile.dart';

class RecipeList extends StatefulWidget {
  final QuerySnapshot snapshot;
  const RecipeList({@required this.snapshot});
  createState() => RecipeListState();
}

class RecipeListState extends State<RecipeList> {
  Map _data;
  List _keys = [];
  initState() {
    _data = widget.snapshot.docChanges.asMap();
    _keys = _data.keys.toList();
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _keys.length,
      itemBuilder: (_, int index) {
        int _newIndex = index + 1;
        Map _indexData = widget.snapshot.docs[index].data();
        final Map _comments =
            _indexData['Comments'] != null ? _indexData['Comments'] : [];
        //TODO keeps fetching new data
        print("INDEXDATA: $_indexData");
        print('COMMENTS: $_comments');
        final List _orderedComments = _comments.keys.toList();
        _orderedComments.sort();
        return Container(
          height: 150,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
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
              ),
            ],
          ),
        );
      },
    );
  }
}
