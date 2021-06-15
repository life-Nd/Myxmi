import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'format_time.dart';

class Comments extends HookWidget {
  const Comments({
    @required Map indexComments,
    @required List commentsKeys,
  })  : _indexComments = indexComments,
        _commentsKeys = commentsKeys;

  final Map _indexComments;
  final List _commentsKeys;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: _size.height / 3,
            width: _size.width / 1,
            margin: EdgeInsets.all(4),
            child: ListView.builder(
              itemCount: _indexComments != null ? _commentsKeys.length : 0,
              itemBuilder: (_, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white70,
                  elevation: 20,
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    title: Text('${_indexComments[_commentsKeys[index]]}'),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${formatTime(_commentsKeys[index])}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
