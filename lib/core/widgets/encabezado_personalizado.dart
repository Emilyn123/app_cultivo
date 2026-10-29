import 'package:flutter/material.dart';

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
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Flecha de retroceso a la izquierda
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: size.width * 0.06, // Tamaño responsivo del icono
              ),
              onPressed: alPresionarAtras ?? () => Navigator.pop(context),
            ),
          ),

          // Título central responsivo
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                titulo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      size.width * 0.045, // Escala con el ancho de la pantalla
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
