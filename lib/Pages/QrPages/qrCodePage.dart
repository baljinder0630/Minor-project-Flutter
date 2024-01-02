import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:qr_bar_code/qr_bar_code.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 250,
                  child: QRCode(data: "https://assistalzheimer.onrender.com/")),
              SizedBox(height: 20),
              Text("Scan the QR Code from Patient's app"),
            ],
          ),
        ),
      ),
    );
  }
}
