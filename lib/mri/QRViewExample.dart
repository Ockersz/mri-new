import 'package:flutter/material.dart';

class QRViewExample extends StatelessWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR View Example')),
      body: const Center(
        child: Text('This is a dummy QR View Example widget.'),
      ),
    );
  }
}
