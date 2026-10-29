import 'dart:ui';
import 'package:flutter/material.dart';

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
        // Cálculo de dimensiones responsivas
        final paddingH = screenWidth < 360 ? 16.0 : 22.0;
        final paddingV = screenWidth < 360 ? 14.0 : 18.0;
        final tamanoTitulo = screenWidth < 360 ? 13.5 : 15.5;
        final tamanoDato = screenWidth < 360 ? 11.5 : 13.0;
        final altoImagen = (constraints.maxWidth * 0.28).clamp(70.0, 105.0);
        final radioBorde = BorderRadius.circular(38);

        // Contenido de los textos
        Widget bloqueTextos = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titulo,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: tamanoTitulo,
                letterSpacing: 0.6,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ...datos.map(
              (dato) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  dato,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: tamanoDato,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );

        // Contenido de la imagen
        Widget bloqueImagen = ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: altoImagen,
            maxWidth: constraints.maxWidth * 0.42,
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
              padding: EdgeInsets.symmetric(
                horizontal: paddingH,
                vertical: paddingV,
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
