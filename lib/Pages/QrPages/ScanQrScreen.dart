import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/QrPages/qrScannerPage.dart';
import 'package:minor_project/Provider/userProvider.dart';

class ScanQrScreen extends ConsumerStatefulWidget {
  const ScanQrScreen({super.key});

  @override
  ConsumerState<ScanQrScreen> createState() => _ScanQrState();
}

class _ScanQrState extends ConsumerState<ScanQrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QRScanPage()));
                },
                child: Text("Scan QR Code")),
          ),
        ],
      ),
    );
  }
}
