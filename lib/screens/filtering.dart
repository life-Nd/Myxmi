import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';

import 'filtered.dart';

class FilteringScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return SizedBox(
      height: _size.height / 1.05,
      width: _size.height / 1.1,
      child: ListView(
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'food'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'drinks'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${'vape'.tr()}s',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'diet'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
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

@immutable
class Filter extends StatefulWidget {
  final String legend;
  const Filter(this.legend);
  @override
  State<StatefulWidget> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
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
          children: [
            SizedBox(
              height: _size.height / 3,
              width: _size.width / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/${widget.legend}.jpg',
                  cacheHeight: 1000,
                  cacheWidth: 1000,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Text(
              widget.legend.tr(),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
