import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final ancho = constraints.maxWidth;

        // Cálculos relativos a la celda con límites seguros
        final double altoImagen = (ancho * 0.68).clamp(90.0, 140.0);
        final double desplazamientoTop = (altoImagen * 0.42).clamp(32.0, 50.0);
        final double paddingSuperior = (altoImagen * 0.70).clamp(48.0, 80.0);
        final double radioBorde = (ancho * 0.10).clamp(16.0, 22.0);

        return Stack(
          clipBehavior: Clip.none, // Permite que la imagen sobresalga
          alignment: Alignment.bottomCenter,
          children: [
            // 1. Tarjeta de fondo
            ClipRRect(
              borderRadius: BorderRadius.circular(radioBorde),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: paddingSuperior,
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF233526).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(radioBorde),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nombre del cultivo
                      AutoSizeText(
                        nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        minFontSize: 10.0,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),

                      // Parámetros técnicos
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _itemDato('PH', ph),
                          const SizedBox(height: 2.0),
                          _itemDato('CE', ce),
                          const SizedBox(height: 2.0),
                          _itemDato('TEMP', temp),
                          const SizedBox(height: 2.0),
                          _itemDato('HUM', hum),
                        ],
                      ),

                      // Botón
                      SizedBox(
                        width: double.infinity,
                        height: 32.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF388E3C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                          ),
                          onPressed: alPresionar,
                          child: const AutoSizeText(
                            'SELECCIONAR',
                            maxLines: 1,
                            minFontSize: 9.0,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Imagen sobresaliente
            Positioned(
              top: -desplazamientoTop,
              left: 0,
              right: 0,
              child: SizedBox(
                height: altoImagen,
                child: Image.asset(
                  imagenPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.eco_outlined,
                    color: Colors.white54,
                    size: 36.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _itemDato(String etiqueta, String valor) {
    return AutoSizeText(
      '$etiqueta: $valor',
      maxLines: 2,
      minFontSize: 8.0,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
