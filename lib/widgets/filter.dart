import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/screens/filtered.dart';

class Filter extends StatefulWidget {
  final String legend;

  const Filter({Key key, this.legend}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final bool _kIsWeb = kIsWeb;
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
              height: _kIsWeb ? _size.height / 3 : _size.height / 3.7,
              width: _kIsWeb ? _size.width / 4 : _size.width / 1.8,
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
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
