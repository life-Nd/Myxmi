import 'package:ai_barcode/ai_barcode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:permission_handler/permission_handler.dart';

// late String _label;
late Function(String result) _resultCallback;

class AppBarcodeScannerWidget extends StatefulWidget {
  AppBarcodeScannerWidget.defaultStyle({
    Function(String result)? resultCallback,
    // String label = 'Reload',
  }) {
    _resultCallback = resultCallback ?? (String result) {};
    // _label = label;
  }

  @override
  _AppBarcodeState createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return _BarcodePermissionWidget();
  }
}

class _BarcodePermissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BarcodePermissionWidgetState();
  }
}

class _BarcodePermissionWidgetState extends State<_BarcodePermissionWidget> {
  bool _isGranted = false;

  bool _useCameraScan = true;

  final String _inputValue = "";

  @override
  void initState() {
    super.initState();
  }

  Future _requestMobilePermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TargetPlatform _platform = Theme.of(context).platform;
    if (!kIsWeb) {
      if (_platform == TargetPlatform.android ||
          _platform == TargetPlatform.iOS) {
        _requestMobilePermission();
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    } else {
      setState(() {
        _isGranted = true;
      });
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: _isGranted
              ? _useCameraScan
                  ? _BarcodeScannerWidget()
                  : Container()
              : Center(
                  child: RawMaterialButton(
                    onPressed: () {
                      _requestMobilePermission();
                    },
                    child: Text('requestPermission'.tr()),
                  ),
                ),
        ),
        if (_useCameraScan) ...[
          Consumer(
            builder: (_, ref, child) {
              final _router = ref.watch(routerProvider);
              return RawMaterialButton(
                onPressed: () {
                  _router.pushPage(
                    name: '/add-product-manually',
                  );
                },
                child: Text('manualInput'.tr()),
              );
            },
          ),
        ] else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RawMaterialButton(
                fillColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  setState(() {
                    _useCameraScan = true;
                  });
                  debugPrint('_inputValue: $_inputValue');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${'reloadScanner'.tr()} '),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _BarcodeScannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  late ScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(
      scannerResult: (result) {
        _resultCallback(result);
      },
      scannerViewCreated: () {
        final TargetPlatform _platform = Theme.of(context).platform;
        if (TargetPlatform.iOS == _platform) {
          Future.delayed(const Duration(seconds: 2), () {
            _scannerController.startCamera();
            _scannerController.startCameraPreview();
          });
        } else {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        _getScanWidgetByPlatform(),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: IconButton(
            onPressed: () {
              _scannerController.startCameraPreview();
            },
            icon: const Icon(Icons.refresh_rounded),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _getScanWidgetByPlatform() {
    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}
