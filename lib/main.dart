import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const BancoDeImagensApp());
}

class BancoDeImagensApp extends StatelessWidget {
  const BancoDeImagensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco de Imagens CDM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}
