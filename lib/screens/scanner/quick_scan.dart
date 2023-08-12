import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expo_in/design-system/app_theme.dart';
import 'package:expo_in/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../componenets/create_route.dart';

class QuickScan extends StatefulWidget {
  const QuickScan({Key? key}) : super(key: key);

  @override
  State<QuickScan> createState() => _QuickScanState();
}

class _QuickScanState extends State<QuickScan> {
  MobileScannerController cameraController = MobileScannerController();
  String? documentId;
  bool alreadyNavigated = false;

  @override
  void initState() {
    super.initState();
    cameraController.start();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.primeAppColor,
          title: const Text('Scan QR'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) async {
            final List<Barcode> barcodes = capture.barcodes;
            bool dataFound = false;

            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
              // get the document from Firebase
              final snapshot =
              await FirebaseFirestore.instance.collection('Users').doc(barcode.rawValue).get();
              if (snapshot.exists) {
                // if document exists and its 'Type' field matches a certain value, navigate to a new page
                if (!alreadyNavigated) {
                  setState(() {
                    documentId = barcode.rawValue;
                    dataFound = true;
                    alreadyNavigated = true;
                  });

                  await cameraController.stop();
                  if (!mounted) return;
                    Navigator.of(context)
                        .push(createRoute(Profile(type: 'Quick-Scan', uid: documentId)))
                        .then((_) async {
                      setState(() {
                        alreadyNavigated = false;
                      });

                    await cameraController.start();
                  });
                }
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid QR"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

