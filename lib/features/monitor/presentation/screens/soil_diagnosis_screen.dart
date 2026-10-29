import 'package:flutter/material.dart';
import '../../../crops/presentation/screens/seleccion_cultivo.dart'; // Ruta al catálogo de cultivos

class SoilDiagnosisScreen extends StatelessWidget {
  const SoilDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        40,
        65,
        49,
      ), // Fondo verde muy oscuro
      body: SafeArea(
        child: Column(
          children: [
            // --- ENCABEZADO Y TÍTULOS ---
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Column(
                    children: const [
                      Text(
                        'Tu tierra carece de los',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'siguientes parametros necesarios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tus parametros',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- ILUSTRACIÓN CENTRAL (Tierra con brotes) ---
            // Usaremos un emoji grande mientras conectas tu asset oficial
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Image.asset(
                'assets/images/hojitas.png', // Conectado a tu imagen de Drive
                height: 100,
                fit: BoxFit.contain,
              ),
            ),

            // --- CUADRÍCULA DE MÉTRICAS (2x2) ---
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: 20,
                ),
                crossAxisCount: 2,
                crossAxisSpacing: size.width * 0.04,
                mainAxisSpacing: size.height * 0.02,
                childAspectRatio: 1.1, // Hace las tarjetas casi cuadradas
                children: const [
                  MetricCard(
                    imagenPath: 'assets/images/PH.png', // Representación del pH
                    titulo: 'PH',
                    valor: '4.8',
                    alertaTexto: 'FUERA DE\nRANGO',
                    mostrarAdvertencia: false, // Color rojo oscuro
                  ),
                  MetricCard(
                    imagenPath: 'assets/images/CE.png', // Representación de CE
                    titulo: 'CE',
                    valor: '1.4 Ms/cm',
                    alertaTexto: 'FUERA DE\nRANGO',
                    mostrarAdvertencia: false,
                  ),
                  MetricCard(
                    imagenPath: 'assets/images/TEMPERATURA.png', // Termómetro
                    titulo: 'TEMP',
                    valor: '22°C',
                    alertaTexto: 'NIVEL\nBAJO',
                    mostrarAdvertencia: false, // Color negro estándar
                  ),
                  MetricCard(
                    imagenPath: 'assets/images/HUMEDAD.png', // Agua/Tierra
                    titulo: 'HUMEDAD',
                    valor: '35%',
                    alertaTexto: 'NIVEL\nBAJO',
                    mostrarAdvertencia: false,
                  ),
                ],
              ),
            ),

            // --- BOTÓN INFERIOR ---
            Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA5CFA1), // Verde pálido
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Redirige al Catálogo de Cultivos
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeleccionCultivo(),
                      ),
                    );
                  },
                  child: const Text(
                    'CULTIVOS RECOMENDADOS',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET PARA LAS TARJETAS DE MÉTRICAS ---
class MetricCard extends StatelessWidget {
  final String imagenPath; // La imagen principal
  final String titulo; // El texto
  final String valor; // El número leído por el sensor
  final String alertaTexto; // Lo que dirá la alerta
  final bool
  mostrarAdvertencia; // true si queremos que salga el logo rojo de advertencia

  const MetricCard({
    super.key,
    required this.imagenPath,
    required this.titulo,
    required this.valor,
    required this.alertaTexto,
    this.mostrarAdvertencia = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD6DBDB), // Gris claro del cubo
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Imagen principal que tú le pases (la verde)
              // Usamos Flexible para que no ocupe más espacio del que debe
              Flexible(
                child: Image.asset(
                  imagenPath,
                  height: 70, // Altura un poco más pequeña
                  width: 70,
                  fit: BoxFit.contain,
                ),
              ),
              // 2. Imagen de advertencia condicional
              if (mostrarAdvertencia)
                // Flexible para que los textos de alerta se ajusten
                Flexible(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/advertencia.png',
                        height: 20, // Altura un poco más pequeña
                        width: 20,
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        // Encoge el texto si no cabe
                        fit: BoxFit.scaleDown,
                        child: Text(
                          alertaTexto,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. El Título que le pases
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // 4. El Valor del sensor
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
