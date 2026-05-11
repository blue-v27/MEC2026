import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatelessWidget {
  final Function(String barcode) onDetect;

  const ScannerScreen({
    super.key,
    required this.onDetect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Food")),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first.rawValue;

          if (barcode != null) {
            Navigator.pop(context);
            onDetect(barcode);
          }
        },
      ),
    );
  }
}