import 'dart:ui';
import 'package:flutter/material.dart';

class TarjetaCultivoElegir extends StatelessWidget {
  final String imagenPath;
  final String nombre;
  final String ph;
  final String ce;
  final String temp;
  final String hum;
  final VoidCallback alPresionar;

  const TarjetaCultivoElegir({
    super.key,
    required this.imagenPath,
    required this.nombre,
    required this.ph,
    required this.ce,
    required this.temp,
    required this.hum,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Stack(
      clipBehavior:
          Clip.none, // Permite que la imagen sobresalga por arriba[cite: 1]
      children: [
        // Tarjeta con efecto desenfocado/esmerilado usando dart:ui
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: size.height * 0.37,
                padding: EdgeInsets.only(
                  top: width * 0.18,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  // Fondo verde translúcido para apreciar el efecto de desenfoque
                  color: const Color(0xFF233526).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    // Parámetros del cultivo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PH: $ph',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'CE: $ce',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'TEMP: $temp',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'HUM: $hum',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Botón
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF388E3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: alPresionar,
                        child: const FittedBox(
                          child: Text(
                            'SELECCIONAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Imagen de la planta que sobresale
        Positioned(
          top: -32,
          left: 0,
          right: 0,
          child: Image.asset(
            imagenPath,
            height: width * 0.35,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
