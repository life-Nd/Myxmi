import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DetailsTile extends HookWidget {
  final String legend;
  final Widget value;
  final Function onTap;
  final Widget leadingWidget;

  const DetailsTile({
    required this.legend,
    required this.value,
    required this.onTap,
    required this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle _titleStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
    );
    return ListTile(
      tileColor: Colors.transparent,
      focusColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 12.0),
          child: leadingWidget,
        ),
      ),
      contentPadding: const EdgeInsets.all(1),
      dense: true,
      onTap: () => onTap,
      title: Text(
        legend,
        style: _titleStyle,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: value,
      ),
    );
  }
}
