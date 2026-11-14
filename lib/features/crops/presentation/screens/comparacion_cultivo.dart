import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/widgets/tarjeta_comparacion.dart';
import '../../../monitor/presentation/screens/soil_diagnosis_screen.dart';
import '../../../monitor/domain/servicio_diagnostico.dart'; // Importamos el cerebro
import '../../../../core/widgets/encabezado_personalizado.dart';

class ComparacionCultivo extends StatefulWidget {
  final int idCultivo;
  // Variables que recibe desde la pantalla de Captura Manual
  final ResultadoDiagnostico resultado;
  final double ph;
  final double ce;
  final double temp;
  final double humedad;

  const ComparacionCultivo({
    super.key,
    required this.idCultivo,
    required this.resultado,
    required this.ph,
    required this.ce,
    required this.temp,
    required this.humedad,
  });

  @override
  State<ComparacionCultivo> createState() => _ComparacionCultivoState();
}

class _ComparacionCultivoState extends State<ComparacionCultivo> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // El cerebro decide automáticamente qué diseño mostrar
    final bool parametrosCumplen = widget.resultado.esApto;

    // --- VARIABLES DINÁMICAS SEGÚN EL CULTIVO ---
    // --- VARIABLES DINÁMICAS SEGÚN EL CULTIVO ---
    String fondoPantalla = '';
    String iconoRequerimiento = '';
    List<String> datosRequeridos = [];

    switch (widget.idCultivo) {
      case 1: // Tomate
        fondoPantalla = 'assets/images/comparacion/fondo_tomate.jpg';
        iconoRequerimiento = 'assets/images/comparacion/icono_tomate.png';
        datosRequeridos = [
          'PH: 6.0 - 6.8',
          'CE: 1.0 - 1.5',
          'TEMP: 11.0 - 34.0°C',
          'HUMEDAD: 65.0 - 85.0%',
        ];
        break;
      case 2: // Frijol
        fondoPantalla = 'assets/images/comparacion/fondo_frijol.jpg';
        iconoRequerimiento = 'assets/images/comparacion/icono_frijol.png';
        datosRequeridos = [
          'PH: 6.0 - 6.8',
          'CE: 0.8 - 1.0',
          'TEMP: 10.0 - 15.0°C',
          'HUMEDAD: 55.0 - 75.0%',
        ];
        break;
      case 3: // Cilantro
        fondoPantalla = 'assets/images/comparacion/fondo_cilantro.jpg';
        iconoRequerimiento = 'assets/images/comparacion/icono_cilantro.png';
        datosRequeridos = [
          'PH: 5.5 - 6.8',
          'CE: 0.8 - 1.2',
          'TEMP: 18.0 - 25.0°C',
          'HUMEDAD: 70.0 - 90.0%',
        ];
        break;
      case 4: // Rábano
        fondoPantalla = 'assets/images/comparacion/fondo_rabano.jpg';
        iconoRequerimiento = 'assets/images/comparacion/icono_rabano.png';
        datosRequeridos = [
          'PH: 5.5 - 6.8',
          'CE: 0.8 - 1.2',
          'TEMP: 15.0 - 22.0°C',
          'HUMEDAD: 70.0 - 90.0%',
        ];
        break;
      default:
        fondoPantalla = 'assets/images/comparacion/fondo_default.jpg';
        iconoRequerimiento = 'assets/images/comparacion/icono_default.png';
        datosRequeridos = ['PH: --', 'CE: --', 'TEMP: --', 'HUMEDAD: --'];
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F1511),
      body: Stack(
        children: [
          // 1. Imagen de la planta de fondo COMPLETA
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(fondoPantalla, fit: BoxFit.cover),
          ),

          // Filtro oscuro (Cambiado a withAlpha)
          Container(color: Colors.black.withAlpha(51)),

          // 2. Contenido de la pantalla
          SafeArea(
            child: Column(
              children: [
                // --- ENCABEZADO ---
                const EncabezadoPersonalizado(titulo: 'comparación'),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        // --- ALERTA DINÁMICA ROJA ---
                        if (!parametrosCumplen)
                          _AlertaRoja(
                            alPresionarVer: () {
                              // Navega a los 4 cubos pasando toda la información real
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SoilDiagnosisScreen(
                                    resultado: widget.resultado,
                                    ph: widget.ph,
                                    ce: widget.ce,
                                    temp: widget.temp,
                                    humedad: widget.humedad,
                                  ),
                                ),
                              );
                            },
                          ),

                        SizedBox(height: size.height * 0.03),

                        // --- TARJETAS ---
                        TarjetaComparacion(
                          titulo: 'REQUERIMIENTOS\nNECESARIOS',
                          imagenPath: iconoRequerimiento,
                          datos: datosRequeridos,
                        ),
                        SizedBox(height: size.height * 0.03),

                        TarjetaComparacion(
                          titulo: 'TU SUELO',
                          imagenPath: 'assets/images/tierra.png',
                          // Ahora inyectamos los números que escribió el agricultor
                          datos: [
                            'PH: ${widget.ph}',
                            'CE: ${widget.ce} dS/m',
                            'TEMP: ${widget.temp}°C',
                            'HUMEDAD: ${widget.humedad}%',
                          ],
                        ),
                        SizedBox(height: size.height * 0.05),

                        // --- ALERTA DINÁMICA VERDE ---
                        if (parametrosCumplen)
                          _AlertaVerde(
                            alPresionarIniciar: () {
                              print('Iniciando seguimiento');
                              // Aquí programaremos más adelante el INSERT final de siembra activa
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

class _AlertaRoja extends StatelessWidget {
  final VoidCallback alPresionarVer;
  const _AlertaRoja({required this.alPresionarVer});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF5C1111).withAlpha(178),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.redAccent.withAlpha(102),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/advertencia.png', height: 35),
                  const Text(
                    'Alerta de desajustes de\nparametros',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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

class _AlertaVerde extends StatelessWidget {
  final VoidCallback alPresionarIniciar;
  const _AlertaVerde({required this.alPresionarIniciar});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
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
