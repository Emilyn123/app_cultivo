import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../core/widgets/tarjeta_comparacion.dart';
import '../../../monitor/presentation/screens/soil_diagnosis_screen.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';

class ComparacionCultivo extends StatefulWidget {
  const ComparacionCultivo({super.key});

  @override
  State<ComparacionCultivo> createState() => _ComparacionCultivoState();
}

class _ComparacionCultivoState extends State<ComparacionCultivo> {
  // 🟢🔴 CAMBIA ESTO PARA PROBAR LOS DOS DISEÑOS
  // true = Muestra la alerta Verde (¡Excelente noticia!)
  // false = Muestra la alerta Roja (Alerta de desajustes)
  bool parametrosCumplen = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1511), // Fondo oscuro
      body: Stack(
        children: [
          // 1. Imagen de la planta de fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/comparacion.png', // Usamos tu nuevo fondo
              fit: BoxFit.cover, // Cubre toda la pantalla
            ),
          ),

          // Un pequeñísimo filtro oscuro por si las letras blancas se pierden
          Container(color: Colors.black.withOpacity(0.2)),

          // 2. Contenido de la pantalla
          SafeArea(
            child: Column(
              children: [
                // --- ENCABEZADO ---
                const EncabezadoPersonalizado(titulo: 'Comparación'),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        // --- ALERTA DINÁMICA (ARRIBA SI ES ROJA) ---
                        if (!parametrosCumplen)
                          _AlertaRoja(
                            alPresionarVer: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SoilDiagnosisScreen(),
                                ),
                              );
                            },
                          ),

                        SizedBox(height: size.height * 0.03),

                        // --- TARJETA 1: REQUERIMIENTOS ---
                        TarjetaComparacion(
                          titulo: 'REQUERIMIENTOS\nNECESARIOS',
                          imagenPath: 'assets/images/tomates.png',
                          datos: const [
                            'PH: 5.8 - 6.8',
                            'CE: 2.0 a 2.2 mS/cm',
                            'TEMP: 20 y 30°C',
                            'HUMEDAD: 60% - 80%',
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),

                        // --- TARJETA 2: TU SUELO ---
                        TarjetaComparacion(
                          titulo: 'TU SUELO',
                          imagenPath:
                              'assets/images/tierra.png', // O una imagen de tierra
                          imagenALaDerecha: true,
                          datos: const [
                            'PH: ......',
                            'CE:......',
                            'TEMP: .....',
                            'HUMEDAD: .....',
                          ],
                        ),
                        SizedBox(height: size.height * 0.05),

                        // --- ALERTA DINÁMICA (ABAJO SI ES VERDE) ---
                        if (parametrosCumplen)
                          _AlertaVerde(
                            alPresionarIniciar: () {
                              // Aquí programaremos el inicio de la Etapa 1
                              print('Iniciando seguimiento');
                            },
                          ),

                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// WIDGETS INTERNOS DE LA PANTALLA
// =====================================================================

// Molde para la Alerta Roja (Ahora con efecto cristal)
class _AlertaRoja extends StatelessWidget {
  final VoidCallback alPresionarVer;

  const _AlertaRoja({required this.alPresionarVer});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ), // Desenfoque del fondo
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            // El color ahora tiene ".withOpacity(0.7)" para dejar ver la planta
            color: const Color(0xFF5C1111).withAlpha(178),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.redAccent.withAlpha(102),
              width: 1.5,
            ), // Borde sutil
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/advertencia.png', height: 35),
                  const Text(
                    'Alerta de desajustes\n de parametros',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Image.asset('assets/images/advertencia.png', height: 35),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE55A5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                ),
                onPressed: alPresionarVer,
                child: const Text(
                  'ver',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Molde para la Alerta Verde (Ahora con efecto cristal)
class _AlertaVerde extends StatelessWidget {
  final VoidCallback alPresionarIniciar;

  const _AlertaVerde({required this.alPresionarIniciar});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ), // Desenfoque del fondo
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // El color ahora tiene ".withOpacity(0.7)"
            color: const Color(0xFF2E5325).withAlpha(178),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.greenAccent.withAlpha(102),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    '¡Excelente noticia!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Tus parámetros de suelo\ncumplen con los requerimientos',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: alPresionarIniciar,
                child: const FittedBox(
                  child: Text(
                    'Iniciar seguimiento de cultivo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
