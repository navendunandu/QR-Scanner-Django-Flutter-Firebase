import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/qr_result.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Handle scanned QR data here
      print(scanData.code);
      String? data = scanData.code;
      Map<String, dynamic> jsonData = jsonDecode(data!);
      controller.dispose();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRResult(qrData: jsonData),
          ));
      // Add your logic here for what to do with the scanned data
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
