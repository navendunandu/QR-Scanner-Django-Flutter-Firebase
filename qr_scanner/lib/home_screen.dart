import 'package:flutter/material.dart';
import 'package:qr_scanner/qr_scanner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'QR Scanner',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to scanner screen for registration
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScanner()),
                );
              },
              child: const Text('Click here to open scanner for registration'),
            ),
          ],
        ),
      ),
    );
  }
}
