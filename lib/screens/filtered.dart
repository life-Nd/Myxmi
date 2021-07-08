import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'recipes_screen.dart';

class Filtered extends StatefulWidget {
  final String legend;
  const Filtered(this.legend);
  @override
  State<StatefulWidget> createState() => _FilteredState();
}

class _FilteredState extends State<Filtered> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.legend.tr()}s'),
      ),
      body: RecipesScreen(
        legend: widget.legend,
      ),
    );
  }
}
