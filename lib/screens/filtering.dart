import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';

import 'filtered.dart';

class FilteringScreen extends HookWidget {
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height / 1.05,
      width: _size.height / 1.1,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          _DrinksFilter(),
          _FoodsFilter(),
          _DietsFilter(),
          _VapesFilter(),
        ],
      ),
    );
  }
}

class _FoodsFilter extends HookWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'food'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Filter(
                'breakfast',
              ),
              Filter(
                'appetizer',
              ),
              Filter(
                'salad',
              ),
              Filter(
                'soup',
              ),
              Filter(
                'dinner',
              ),
              Filter(
                'dessert',
              ),
              Filter(
                'allFoods',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DrinksFilter extends HookWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${'drinks'.tr()}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Filter(
                'cocktail',
              ),
              Filter(
                'smoothie',
              ),
              Filter(
                'shake',
              ),
              Filter(
                'allDrinks',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VapesFilter extends HookWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${'vape'.tr()}s',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Filter(
                'nicotine',
              ),
              Filter(
                'thc',
              ),
              Filter(
                'cbd',
              ),
              Filter(
                'allVapes',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DietsFilter extends HookWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'diet'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Filter(
                'vegan',
              ),
              Filter(
                'vegetarian',
              ),
              Filter(
                'keto',
              ),
              Filter(
                'allDiets',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Filter extends StatefulWidget {
  final String legend;
  Filter(this.legend);
  createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // widget.legend[0].toUpperCase() + widget.legend.substring(1);
    return GestureDetector(
      onTap: () {
        // TODO change the future and switch based on category
        // and subcategory.

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Filtered(
              widget.legend,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: _size.height / 3,
              width: _size.width / 2,
              child: ClipRRect(
                child: Image.asset(
                  'assets/${widget.legend}.jpg',
                  cacheHeight: 1000,
                  cacheWidth: 1000,
                  fit: BoxFit.fitHeight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Text(
              '${widget.legend}'.tr(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
