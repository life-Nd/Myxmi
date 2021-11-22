import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String type;

  const NoData({Key key, @required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset('assets/data_not_found.png')),
          Expanded(
            child: Text(
              'no$type'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
