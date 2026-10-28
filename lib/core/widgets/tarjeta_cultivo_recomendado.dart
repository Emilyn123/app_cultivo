import 'package:flutter/material.dart';
import 'tarjeta_cristal.dart'; // Importamos tu nuevo widget de cristal

class TarjetaCultivoRecomendado extends StatelessWidget {
  final IconData icono;
  final String nombre;

  const TarjetaCultivoRecomendado({
    super.key,
    required this.icono,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TarjetaCristal(
        // Usamos el widget público
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: Colors.white, size: 45),
              const SizedBox(height: 15),
              Text(
                nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
