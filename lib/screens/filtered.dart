import 'package:flutter/material.dart';
import 'recipes.dart';
import 'package:easy_localization/easy_localization.dart';

class Filtered extends StatefulWidget {
  final String legend;
  Filtered(this.legend);
  createState() => _FilteredState();
}

class _FilteredState extends State<Filtered> {
  
  Widget build(BuildContext context) {
    String _legend =
        '${widget.legend[0].toUpperCase() + widget.legend.substring(1)}s';
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('$_legend'.tr()),
      ),
      body: Container(
        height: _size.height,
        child: RecipesScreen(widget.legend),
      ),
    );
  }
}
