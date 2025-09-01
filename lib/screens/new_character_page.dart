import 'package:flutter/material.dart';

class NewCharacterPage extends StatelessWidget {
  const NewCharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Karakter')),
      body: const Center(
        child: Text('Karakter oluşturma arayüzü buraya gelecek.'),
      ),
    );
  }
}
