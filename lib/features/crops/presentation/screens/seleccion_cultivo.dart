import 'package:flutter/material.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../../core/widgets/tarjeta_cultivo_elegir.dart';
//import 'comparacion_cultivo.dart';

class SeleccionCultivo extends StatelessWidget {
  const SeleccionCultivo({super.key});

  @override
  Widget build(BuildContext context) {
    // Tomamos las medidas de la pantalla para el diseño responsivo
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(
        0xFF131E17,
      ), // Fondo verde muy oscuro, casi negro, igual al diseño
      body: SafeArea(
        child: Column(
          children: [
            // --- ENCABEZADO: Botón Atrás y Título ---
            const EncabezadoPersonalizado(titulo: 'Selecciona tu cultivo'),

            // --- CUADRÍCULA DE CULTIVOS (Responsiva) ---
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.all(size.width * 0.05),
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: size.width * 0.04,
                mainAxisSpacing: size.height * 0.03,
                childAspectRatio:
                    0.52, // Proporción de la tarjeta (más alta que ancha para que quepa el texto)
                children: [
                  TarjetaCultivoElegir(
                    imagenPath:
                        'assets/images/tomate_rojo.png', // Nombre sugerido para tu imagen de Drive
                    nombre: 'TOMATE ROJO',
                    ph: '5.8 - 6.8',
                    ce: '2.0 a 2.2 mS/cm',
                    temp: '20 y 30°C',
                    humedad: '60% - 80%',
                    alPresionar: () {},
                  ),
                  TarjetaCultivoElegir(
                    imagenPath: 'assets/images/frijol.png',
                    nombre: 'FRIJOL',
                    ph: '6.5 y 7.5',
                    ce: 'Menor a 1.0 dS/m',
                    temp: '19-25°C',
                    humedad: '12% a 13%',
                    alPresionar: () {},
                  ),
                  TarjetaCultivoElegir(
                    imagenPath:
                        'assets/images/cilantro.png', // Usa la imagen "Gemini_Generated_Image_ea6px..." de tu Drive
                    nombre: 'CILANTRO',
                    ph: '6.2-7.5',
                    ce: '1.5 y 3 mS',
                    temp: '15 y 20 °C',
                    humedad: '75%',
                    alPresionar: () {},
                  ),
                  TarjetaCultivoElegir(
                    imagenPath: 'assets/images/rabano.png',
                    nombre: 'RABANO',
                    ph: '6.0 - 7.0',
                    ce: '1.2 a 1.5 mS/cm',
                    temp: '18 °C y 22 °C',
                    humedad: '60% y 80%',
                    alPresionar: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
