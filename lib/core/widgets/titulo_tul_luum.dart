import 'package:flutter/material.dart';

class TituloTulLuum extends StatelessWidget {
  final String texto;
  final double tamanoFuente;
  final Color colorRelleno;

  const TituloTulLuum({
    super.key,
    this.texto = "Tul lu'um IoT",
    this.tamanoFuente = 42.0,
    this.colorRelleno = const Color(0xFFE8F5E9),
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Stack(
        children: [
          // Capa inferior: Borde negro
          Text(
            texto,
            textAlign: TextAlign.center, // <-- AGREGAMOS ESTO PARA CENTRAR
            style: TextStyle(
              fontSize: tamanoFuente,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.black87,
            ),
          ),
          // Capa superior: Relleno de color
          Text(
            texto,
            textAlign: TextAlign.center, // <-- Y TAMBIÉN AQUÍ
            style: TextStyle(
              fontSize: tamanoFuente,
              fontWeight: FontWeight.bold,
              color: colorRelleno,
            ),
          ),
        ],
      ),
    );
  }
}
