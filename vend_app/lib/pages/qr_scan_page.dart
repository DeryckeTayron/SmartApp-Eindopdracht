import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vend_app/pages/vending_machine_info_page.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  Future<void> scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No id found'),
        ),
      );
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VendingMachineInfoPage(scanResult: barcodeScanRes)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scan'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: scanBarcode,
              child: const Text('Scan Code'),
            ),
          ],
        ),
      ),
    );
  }
}
