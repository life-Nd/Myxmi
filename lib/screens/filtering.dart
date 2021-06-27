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
          _FoodFilter(),
          _DrinksFilter(),
          _VapesFilter(),
          _DietFilter(),
        ],
      ),
    );
  }
}

class _FoodFilter extends HookWidget {
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
              _Filter(
                'breakfast',
              ),
              _Filter(
                'appetizer',
              ),
              _Filter(
                'salad',
              ),
              _Filter(
                'soup',
              ),
              _Filter(
                'dinner',
              ),
              _Filter(
                'dessert',
              ),
              _Filter(
                'allFood',
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
            '${'drink'.tr()}s',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _Filter(
                'cocktail',
              ),
              _Filter(
                'smoothie',
              ),
              _Filter(
                'shake',
              ),
              _Filter(
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
              _Filter(
                'nicotine',
              ),
              _Filter(
                'thc',
              ),
              _Filter(
                'cbd',
              ),
              _Filter(
                'allVapes',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DietFilter extends HookWidget {
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
              _Filter(
                'nicotine',
              ),
              _Filter(
                'thc',
              ),
              _Filter(
                'cbd',
              ),
              _Filter(
                'allVapes',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Filter extends StatefulWidget {
  final String legend;
  _Filter(this.legend);
  createState() => _FilterState();
}

class _FilterState extends State<_Filter> {
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
                  cacheHeight: 400,
                  cacheWidth: 400,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Text(
              '${widget.legend}'.tr().toUpperCase(),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
