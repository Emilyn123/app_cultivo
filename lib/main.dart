import 'package:flutter/material.dart';
import 'features/auth/presentation/screens/inicio.dart';

void main() {
  runApp(const CalidadDelSuelo()); // <-- Nombre actualizado aquí
}

class CalidadDelSuelo extends StatelessWidget {
  // <-- Y aquí
  const CalidadDelSuelo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calidad del Suelo', // Este es el nombre que lee el celular
      home: InicioAnimado(),
    );
  }
}
