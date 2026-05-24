// lib/main.dart
import 'package:flutter/material.dart';
import 'med_vet_ini.dart'; // Importa o arquivo da tela inicial

void main() {
  runApp(MedVetApp());
}

class MedVetApp extends StatelessWidget {
  const MedVetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedVet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home:LandingPage(), // Encontra a LandingPage graças ao import acima
    );
  }
}