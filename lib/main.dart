import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/screens/inicio.dart';
import 'core/services/database_service.dart';

void main() async {
  // Asegura que Flutter esté listo antes de arrancar bases de datos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Supabase con tus credenciales
  await Supabase.initialize(
    url: 'https://inhmicfygklgmsdyabog.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImluaG1pY2Z5Z2tsZ21zZHlhYm9nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM1NTg2NjYsImV4cCI6MjEwOTEzNDY2Nn0.-mjZ8WUQRyul_Egl3FrVu6AlGrxeJdjbPMPwCRqSD5A', // Copia la clave larga de Project Settings > API
  );

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
