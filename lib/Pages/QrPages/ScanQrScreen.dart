// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:minor_project/Pages/QrPages/qrScannerPage.dart';

// class ScanQrScreen extends ConsumerStatefulWidget {
//   const ScanQrScreen({super.key});

//   @override
//   ConsumerState<ScanQrScreen> createState() => _ScanQrState();
// }

// class _ScanQrState extends ConsumerState<ScanQrScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Center(
//             child: TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => const QRScanPage()));
//                 },
//                 child: const Text("Scan QR Code")),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/QrPages/qrScannerPage.dart';

class ScanQrScreen extends ConsumerStatefulWidget {
  const ScanQrScreen({Key? key}) : super(key: key);

  @override
  _ScanQrScreenState createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends ConsumerState<ScanQrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const QRScanPage()),
            );
          },
          icon: Icon(Icons.qr_code_scanner),
          label: Text("Scan QR Code"),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Background color
            onPrimary: Colors.white, // Text color
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
