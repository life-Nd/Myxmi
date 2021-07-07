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
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          title: Text('${widget.legend.tr()}s'),
          // expandedHeight: 80.0,
          stretch: true,
          floating: false,
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return RecipesScreen(
              legend: widget.legend,
            );
          }),
        ),
      ]),
    );
  }
}
