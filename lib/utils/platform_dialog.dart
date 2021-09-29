import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends StatelessWidget {
  const PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height / 3,
      ),
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final List<Widget> actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelActionText,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    }
    actions.add(
      PlatformAlertDialogAction(
        color: Colors.red,
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(
          defaultActionText,
          style: const TextStyle(color: Colors.white),
          // key: Key(Keys.alertDefault),
        ),
      ),
    );
    return actions;
  }
}

class PlatformAlertDialogAction extends StatelessWidget {
  const PlatformAlertDialogAction({this.child, this.onPressed, this.color});
  final Color color;
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      elevation: 20,
      onPressed: onPressed,
      child: child,
    );
  }
}
