import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TarjetaCultivoElegir extends StatelessWidget {
  final String imagenPath;
  final String nombre;
  final VoidCallback alPresionar;

  const TarjetaCultivoElegir({
    super.key,
    required this.imagenPath,
    required this.nombre,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ancho = constraints.maxWidth;
        final double radioBorde = (ancho * 0.10).clamp(16.0, 22.0);

        return ClipRRect(
          borderRadius: BorderRadius.circular(radioBorde),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
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
                  // 1. Imagen contenida 100% dentro de la tarjeta
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.asset(
                        imagenPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.eco_outlined,
                              color: Colors.white54,
                              size: 36.0,
                            ),
                      ),
                    ),
                  ),

                  // 2. Nombre del cultivo
                  AutoSizeText(
                    nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    minFontSize: 10.0,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),

                  // 3. Botón
                  SizedBox(
                    width: double.infinity,
                    height: 32.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
        );
      },
    );
  }
}
