import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EncabezadoPersonalizado extends StatelessWidget {
  final String titulo;
  final VoidCallback? alPresionarAtras;

  const EncabezadoPersonalizado({
    super.key,
    required this.titulo,
    this.alPresionarAtras,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // 1. Botón atrás (tamaño fijo estándar)
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 22,
            ),
            onPressed: alPresionarAtras ?? () => Navigator.pop(context),
          ),

          // 2. Título centrado con AutoSizeText (ocupa el resto sin tapar el botón)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AutoSizeText(
                titulo,
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 11,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 3. Espaciador compensador (para que el título quede matemáticamente centrado)
          const SizedBox(width: 47), // Mismo ancho que el IconButton estándar
        ],
      ),
    );
  }
}
