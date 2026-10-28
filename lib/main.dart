import 'package:flutter/material.dart';
import 'features/auth/presentation/screens/inicio.dart';
import 'core/services/database_service.dart';

void main() async {
  // Asegura que Flutter esté listo antes de arrancar bases de datos
  WidgetsFlutterBinding.ensureInitialized();

  // Despierta a SQLite para que cree o lea las tablas
  await DatabaseService.instance.database;

  runApp(const CalidadDelSuelo()); // <-- Nombre actualizado aquí
}

class CalidadDelSuelo extends StatelessWidget {
  // <-- Y aquí
  const CalidadDelSuelo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calidad del Suelo', // Este es el nombre que lee el celular
      home: const InicioAnimado(),
    );
  }
}
