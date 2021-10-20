import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoDetails extends StatelessWidget {
  final String text;
  const NoDetails(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          text.tr(),
      ),
    );
  }
}
