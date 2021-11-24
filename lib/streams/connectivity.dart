import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/utils/no_internet.dart';

class StreamConnectivityBuilder extends StatefulWidget {
  const StreamConnectivityBuilder({
    Key key,
    @required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<StreamConnectivityBuilder> createState() =>
      _StreamConnectivityBuilderState();
}

class _StreamConnectivityBuilderState extends State<StreamConnectivityBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder:
          (context, AsyncSnapshot<ConnectivityResult> connectivitySnapshot) {
        debugPrint('----connectivitySnapshot: ${connectivitySnapshot.data}');
        if (kIsWeb) {
          return widget.child;
        }
        if (!kIsWeb || connectivitySnapshot.hasData) {
          debugPrint('----connectivitySnapshot: ${connectivitySnapshot.data}');
          if (kIsWeb || connectivitySnapshot.data != ConnectivityResult.none) {
            final _connectivityResult = connectivitySnapshot.data;
            debugPrint('---NO CONNECTION---: $_connectivityResult');
            return widget.child;
          } else {
            final _connectivityResult = connectivitySnapshot.data;
            debugPrint('---_connectivityResult---: $_connectivityResult');
            return const NoInternetView();
          }
        } else {
          debugPrint('---NO loading---');
          return const Scaffold(
            body: LoadingColumn(),
          );
        }
      },
    );
  }
}
