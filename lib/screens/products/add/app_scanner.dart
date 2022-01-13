import 'package:ai_barcode/ai_barcode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/screens/products/add/widgets/nutrition_details.dart';
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
        Container(
          margin: const EdgeInsets.only(top: 8),
          height: 7,
          width: 77,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
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
        Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Consumer(
                          builder: (_, ref, child) {
                            final _scannerFlash =
                                ref.watch(scannerFlashProvider);
                            return IconButton(
                              padding: const EdgeInsets.all(2),
                              iconSize: 30,
                              onPressed: () {
                                if (_scannerFlash.isFlashOn) {
                                  _scannerController.closeFlash();
                                  _scannerFlash.toggleFlash(value: false);
                                } else {
                                  _scannerController.openFlash();
                                  _scannerFlash.toggleFlash(value: true);
                                }
                              },
                              icon: Icon(
                                _scannerFlash.isFlashOn
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                                size: 30,
                              ),
                              color: Colors.white,
                            );
                          },
                        ),
                        Consumer(
                          builder: (_, ref, child) {
                            final _productScanner =
                                ref.read(productScannerProvider);

                            return IconButton(
                              padding: const EdgeInsets.all(2),
                              iconSize: 30,
                              onPressed: () {
                                _productScanner.reset();
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  _scannerController.startCameraPreview();
                                });
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              color: Colors.red,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4.0,
                        right: 4.0,
                        top: 2,
                        bottom: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${'poweredBy'.tr()}: ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            width: 150,
                            child: Image.asset(
                              'assets/Open_Food_Facts_logo.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
