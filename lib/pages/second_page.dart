import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page'), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            const Text('This is the second screen from the notification!'),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
