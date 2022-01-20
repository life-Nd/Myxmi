import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String type;
  final double? height;
  const NoData({Key? key, required this.type, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/data_not_found.png',
            height: height ?? MediaQuery.of(context).size.height * 0.3,
          ),
          Text(
            'no$type'.tr(),
          ),
        ],
      ),
    );
  }
}
