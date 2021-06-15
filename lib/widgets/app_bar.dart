import 'package:myxmi/services/auth.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final Widget child;
  const AppBarWidget({Key key, this.child}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        actions: [
          RawMaterialButton(
            child: Icon(Icons.logout, color: Colors.red),
            onPressed: () => AuthHandler().confirmSignOut(context),
          ),
        ],
        title: Text(
          'Myxmi',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: child,
    );
  }
}
