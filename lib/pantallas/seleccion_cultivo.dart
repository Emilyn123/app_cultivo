import 'package:flutter/material.dart';

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
            Padding(
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
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Vuelve al MenuPrincipal
                      },
                    ),
                  ),
                  // Título central
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.greenAccent.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'selecciona tu cultivo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Decoración opcional a los lados (Si tuvieras los iconos de las plantitas del encabezado, irían aquí)
                ],
              ),
            ),

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
                  _TarjetaCultivoElegir(
                    imagenPath:
                        'assets/images/tomate_rojo.png', // Nombre sugerido para tu imagen de Drive
                    nombre: 'TOMATE ROJO',
                    ph: '5.8 - 6.8',
                    ce: '2.0 a 2.2 mS/cm',
                    temp: '20 y 30°C',
                    humedad: '60% - 80%',
                    alPresionar: () {},
                  ),
                  _TarjetaCultivoElegir(
                    imagenPath: 'assets/images/frijol.png',
                    nombre: 'FRIJOL',
                    ph: '6.5 y 7.5',
                    ce: 'Menor a 1.0 dS/m',
                    temp: '19-25°C',
                    humedad: '12% a 13%',
                    alPresionar: () {},
                  ),
                  _TarjetaCultivoElegir(
                    imagenPath:
                        'assets/images/cilantro.png', // Usa la imagen "Gemini_Generated_Image_ea6px..." de tu Drive
                    nombre: 'CILANTRO',
                    ph: '6.2-7.5',
                    ce: '1.5 y 3 mS',
                    temp: '15 y 20 °C',
                    humedad: '75%',
                    alPresionar: () {},
                  ),
                  _TarjetaCultivoElegir(
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

// --- WIDGET DE TARJETA INDIVIDUAL ---
class _TarjetaCultivoElegir extends StatelessWidget {
  final String imagenPath;
  final String nombre;
  final String ph;
  final String ce;
  final String temp;
  final String humedad;
  final VoidCallback alPresionar;

  const _TarjetaCultivoElegir({
    required this.imagenPath,
    required this.nombre,
    required this.ph,
    required this.ce,
    required this.temp,
    required this.humedad,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip
          .none, // Permite que la imagen sobresalga de la tarjeta por arriba
      children: [
        // La tarjeta de fondo verde oscuro
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height:
                MediaQuery.of(context).size.height * 0.32, // Altura relativa
            padding: EdgeInsets.only(
              top: width * 0.15,
              left: 10,
              right: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0xFF233526,
              ), // Tono verde opaco de tus tarjetas
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    nombre,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Parámetros
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PH: $ph',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'CE: $ce',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'TEMP: $temp',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'HUMEDAD: $humedad',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                // Botón
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF388E3C,
                      ), // Verde del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: alPresionar,
                    child: const FittedBox(
                      child: Text(
                        'SELECCIONAR',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // La imagen de la planta que sobresale
        Positioned(
          top: -20, // Empuja la imagen hacia arriba fuera de la tarjeta
          left: 0,
          right: 0,
          child: Image.asset(
            imagenPath,
            height: width * 0.35, // Tamaño de la planta
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
