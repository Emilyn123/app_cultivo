import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TarjetaComparacion extends StatelessWidget {
  final String titulo;
  final String imagenPath;
  final List<String> datos;

  /// Si es true, coloca el texto a la izquierda y la imagen a la derecha.
  final bool imagenALaDerecha;

  const TarjetaComparacion({
    super.key,
    required this.titulo,
    required this.imagenPath,
    required this.datos,
    this.imagenALaDerecha = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Cálculo proporcional con clamp para la imagen
        final double altoImagen = (constraints.maxWidth * 0.28).clamp(
          70.0,
          105.0,
        );
        final double anchoImagenMax = (constraints.maxWidth * 0.40).clamp(
          75.0,
          130.0,
        );
        final BorderRadius radioBorde = BorderRadius.circular(38);

        // Contenido de los textos
        // Bloque de textos utilizando AutoSizeText
        Widget bloqueTextos = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoSizeText(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16.0,
                letterSpacing: 0.6,
                height: 1.2,
              ),
              maxLines: 2,
              minFontSize: 12.0,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ...datos.map(
              (dato) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: AutoSizeText(
                  dato,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                  maxLines: 1,
                  minFontSize: 9.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );

        // Bloque de la imagen ajustado con restricciones y clamp
        Widget bloqueImagen = ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: altoImagen,
            maxWidth: anchoImagenMax,
          ),
          child: Image.asset(
            imagenPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white54,
              size: 40,
            ),
          ),
        );

        return ClipRRect(
          borderRadius: radioBorde,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: radioBorde,
                border: Border.all(
                  color: Colors.white.withOpacity(0.28),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: imagenALaDerecha
                    ? [
                        Expanded(flex: 3, child: bloqueTextos),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: Center(child: bloqueImagen)),
                      ]
                    : [
                        Expanded(flex: 2, child: Center(child: bloqueImagen)),
                        const SizedBox(width: 12),
                        Expanded(flex: 3, child: bloqueTextos),
                      ],
              ),
            ),
          ),
        );
      },
    );
  }
}
