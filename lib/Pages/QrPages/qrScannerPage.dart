import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQrView(context),
              if (barcode != null) buildResult(),
            ],
          ),
        ),
      );

  Widget buildResult() => GestureDetector(
        onTap: () {
          // Handle navigation to the web page using the URL from the barcode
          // For example, you can use the url_launcher package.
          // Here, I'm just printing the URL to the console.
          print('Opening URL: ${barcode!.code}');
        },
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              'URL: ${barcode!.code}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          overlayColor:
              Colors.transparent, // Set overlay color to be transparent
          borderColor: Theme.of(context).colorScheme.secondary,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen(
      (barCode) => setState(() {
        this.barcode = barCode;

        // Pause the camera when a QR code is scanned
        controller.pauseCamera();

        // Optionally, you can add a delay before navigating to the white page
        Future.delayed(Duration(seconds: 2), () {
          // Navigate to the white page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => buildResult()),
          );
        });
      }),
    );
  }
}
