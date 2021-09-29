import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAwareAssetImage extends StatelessWidget {
  const PlatformAwareAssetImage({
    Key key,
    this.asset,
    this.package,
  }) : super(key: key);

  final String asset;
  final String package;

  @override
  Widget build(BuildContext context) {
    debugPrint('Package: $package');
    debugPrint('asset: $asset');
    if (kIsWeb) {
      return Image.network(
        'assets/${package == null ? '' : 'packages/$package/'}$asset',
        cacheHeight: 1000,
        cacheWidth: 1000,
        fit: BoxFit.fitWidth,
      );
    }

    return Image.asset(
      'assets/$asset',
      package: package,
      cacheHeight: 1000,
      cacheWidth: 1000,
      fit: BoxFit.fitWidth,
    );
  }
}
