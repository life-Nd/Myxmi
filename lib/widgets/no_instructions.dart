import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NoInstructions extends StatelessWidget {
  final String text;
  const NoInstructions(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(),
    );
  }
}
