import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/pages/filtered.dart';

class MenuItem extends StatefulWidget {
  final String legend;
  final String filter;
  final String url;
  const MenuItem(
      {Key key,
      @required this.legend,
      @required this.url,
      @required this.filter})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  final bool _kIsWeb = kIsWeb;
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (_, watch, __) {
      return InkWell(
        onTap: () {
          debugPrint('key: category ,value: ${widget.legend}');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Filtered(
                legend: widget.legend,
                filter: widget.filter,
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
                height: _kIsWeb && _size.width > 700
                    ? _size.height / 2.4
                    : _size.height / 3.7,
                width: _kIsWeb && _size.width > 700
                    ? _size.width / 3.2
                    : _size.width / 1.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/${widget.legend}.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                widget.legend.tr(),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 4),
                width: _kIsWeb && _size.width > 700
                    ? _size.width / 3.2
                    : _size.width / 1.8,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.url,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
