import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Неизвестный';
  final String textCancel = 'Отмена';
  final String codeColor = '#ff6666';
  final bool isShowFlashIcon = true;

  @override
  void initState() {
    super.initState();
  }

  // Сообщения платформы асинхронны, поэтому мы инициализируем асинхронный метод
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Сообщения платформы могут давать сбой, поэтому мы используем try / catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          codeColor, textCancel, isShowFlashIcon, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Не удалось получить версию платформы.';
    }
    
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes.length == 13) {
        _scanBarcode = barcodeScanRes;
      } else {
        _scanBarcode = 'Вы не используете стандарт ean13';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Cканирование штрих-кода')),
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      scanBarcodeNormal();
                    },
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text(
                      'Начать сканирование штрих-кода',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Результат сканирования : $_scanBarcode\n',
                    style: TextStyle(
                        fontSize: 20,
                        color: _scanBarcode.length == 13
                            ? Colors.green
                            : Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
