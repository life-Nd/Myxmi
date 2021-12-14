import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoadingColumn extends StatelessWidget {
  const LoadingColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('loading'.tr()),
          const SizedBox(height: 10),
          const CircularProgressIndicator(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
