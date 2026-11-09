import 'package:flutter/material.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../../core/widgets/tarjeta_cultivo_elegir.dart';
import 'comparacion_cultivo.dart';

class SeleccionCultivo extends StatelessWidget {
  const SeleccionCultivo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Márgenes exteriores y separación de filas
    final paddingLateral = (size.width * 0.05).clamp(14.0, 24.0);
    final espaciadoColumnas = (size.width * 0.04).clamp(12.0, 18.0);
    final separacionFilas = (size.height * 0.045).clamp(28.0, 44.0);

    // Columnas adaptativas: 2 en móviles, 3 o 4 en pantallas amplias
    final int columnas = size.width > 900 ? 4 : (size.width > 600 ? 3 : 2);

    // Proporción de la celda: más alargada en móviles para asegurar espacio al contenido
    final double proporcionAspecto = size.width > 600 ? 0.65 : 0.54;

    return Scaffold(
      backgroundColor: const Color(0xFF131E17),
      body: SafeArea(
        child: Column(
          children: [
            const EncabezadoPersonalizado(titulo: 'Selecciona tu cultivo'),
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.symmetric(
                  horizontal: paddingLateral,
                  vertical:
                      30.0, // Margen superior para la imagen de la primera fila
                ),
                crossAxisCount: columnas,
                crossAxisSpacing: espaciadoColumnas,
                mainAxisSpacing: separacionFilas,
                childAspectRatio: proporcionAspecto,
                physics: const BouncingScrollPhysics(),
                children: [
                  TarjetaCultivoElegir(
                    imagenPath: 'assets/images/tomate_rojo.png',
                    nombre: 'TOMATE ROJO',
                    ph: '5.8 - 6.8',
                    ce: '2.0 a 2.2 mS/cm',
                    temp: '20 y 30°C',
                    hum: '60% - 80%',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComparacionCultivo(),
                        ),
                      );
                    },
                  ),
                  TarjetaCultivoElegir(
                    imagenPath: 'assets/images/frijol.png',
                    nombre: 'FRIJOL',
                    ph: '6.5 y 7.5',
                    ce: 'Menor a 1.0 dS/m',
                    temp: '19-25°C',
                    hum: '12% a 13%',
                    alPresionar: () {},
                  ),
                  TarjetaCultivoElegir(
                    imagenPath: 'assets/images/cilantro.png',
                    nombre: 'CILANTRO',
                    ph: '6.2-7.5',
                    ce: '1.5 y 3 mS',
                    temp: '15 y 20 °C',
                    hum: '75%',
                    alPresionar: () {},
                  ),
                  TarjetaCultivoElegir(
                    imagenPath: 'assets/images/rabano.png',
                    nombre: 'RABANO',
                    ph: '6.0 - 7.0',
                    ce: '1.2 a 1.5 mS/cm',
                    temp: '18 °C y 22 °C',
                    hum: '60% y 80%',
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
