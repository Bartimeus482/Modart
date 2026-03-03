import 'package:flutter/material.dart';
import 'pages/auth_gate.dart';

void main() {
  runApp(const ClothesLibraryApp());
}

class ClothesLibraryApp extends StatelessWidget {
  const ClothesLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clothes Library',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthGate(),
    );
  }
}
