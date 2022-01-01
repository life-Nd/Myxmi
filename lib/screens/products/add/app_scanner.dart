import 'package:ai_barcode/ai_barcode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

late String _label;
late Function(String result) _resultCallback;

class AppBarcodeScannerWidget extends StatefulWidget {
  AppBarcodeScannerWidget.defaultStyle({
    Function(String result)? resultCallback,
    String label = 'Single number(单号)',
  }) {
    _resultCallback = resultCallback ?? (String result) {};
    _label = label;
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

  String _inputValue = "";

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
                  : _BarcodeInputWidget.defaultStyle(
                      changed: (String value) {
                        _inputValue = value;
                      },
                    )
              : Center(
                  child: RawMaterialButton(
                    onPressed: () {
                      _requestMobilePermission();
                    },
                    child: Text('requestPermission'.tr()),
                  ),
                ),
        ),
        if (_useCameraScan)
          RawMaterialButton(
            onPressed: () {
              setState(() {
                _useCameraScan = false;
              });
            },
            child: Text('manualInput'.tr()),
          )
        else
          Row(
            children: [
              RawMaterialButton(
                onPressed: () {
                  setState(() {
                    _useCameraScan = true;
                  });
                },
                child: Text('${'scanning'.tr()} $_label'),
              ),
              RawMaterialButton(
                onPressed: () {
                  _resultCallback(_inputValue);
                },
                child: Text('yes'.tr()),
              ),
            ],
          ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _BarcodeInputWidget extends StatefulWidget {
  late ValueChanged<String> _changed;

  _BarcodeInputWidget.defaultStyle({
    required ValueChanged<String> changed,
  }) {
    _changed = changed;
  }

  @override
  State<StatefulWidget> createState() {
    return _BarcodeInputState();
  }
}

class _BarcodeInputState extends State<_BarcodeInputWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(8)),
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(8)),
            Text(
              "$_label:",
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                onChanged: widget._changed,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
        const Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }
}

///ScannerWidget
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
    return Column(
      children: <Widget>[
        Expanded(
          child: _getScanWidgetByPlatform(),
        )
      ],
    );
  }

  Widget _getScanWidgetByPlatform() {
    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}
