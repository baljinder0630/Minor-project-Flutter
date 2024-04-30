import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/nav.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends ConsumerStatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  ConsumerState<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends ConsumerState<QRScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  bool qrScanned = false;

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
          appBar: AppBar(
            title: const Text("Scan QR Code"),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQrView(context),
              Positioned(
                top: 10,
                child: buildControlButtons(),
              ),
              if (qrScanned)
                const Center(
                    child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ))
            ],
          ),
        ),
      );

  Widget buildControlButtons() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.switch_camera),
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
            ),
            IconButton(
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
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

    controller.scannedDataStream.listen((barCode) async {
      if (barCode.code!.contains(host)) {
        log("Qr scanned: ${barCode.code} ");
        setState(() {
          qrScanned = true;
        });

        controller.pauseCamera();
        controller.dispose();
        if (await ref
            .watch(authStateProvider.notifier)
            .allocateCareTaker(barCode.code!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("CareTaker Allocated",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
          // snackbar
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("CareTaker Allocation Failed",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        }
        // Close the camera
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Navigator.of(context).pop();
        // });
      }
    });
  }
}
