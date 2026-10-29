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
                  vertical: 10,
                ),
                crossAxisCount: 2,
                crossAxisSpacing: size.width * 0.04,
                mainAxisSpacing: size.height * 0.02,
                childAspectRatio: 1.1, // Hace las tarjetas casi cuadradas
                children: const [
                  _MetricCard(
                    iconoPath: 'assets/images/PH.png', // Representación del pH
                    titulo: 'PH',
                    valor: '4.8',
                    alertaTexto: 'FUERA DE\nRANGO',
                    isAlertaPeligro: false, // Color rojo oscuro
                  ),
                  _MetricCard(
                    iconoPath: 'assets/images/CE.png', // Representación de CE
                    titulo: 'CE',
                    valor: '1.4 Ms/cm',
                    alertaTexto: 'FUERA DE\nRANGO',
                    isAlertaPeligro: false,
                  ),
                  _MetricCard(
                    iconoPath: 'assets/images/TEMPERATURA.png', // Termómetro
                    titulo: 'TEMP',
                    valor: '22°C',
                    alertaTexto: 'NIVEL\nBAJO',
                    isAlertaPeligro: false, // Color negro estándar
                  ),
                  _MetricCard(
                    iconoPath: 'assets/images/HUMEDAD.png', // Agua/Tierra
                    titulo: 'HUMEDAD',
                    valor: '35%',
                    alertaTexto: 'NIVEL\nBAJO',
                    isAlertaPeligro: false,
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
class _MetricCard extends StatelessWidget {
  final String iconoPath;
  final String titulo;
  final String valor;
  final String alertaTexto;
  final bool isAlertaPeligro;

  const _MetricCard({
    required this.iconoPath,
    required this.titulo,
    required this.valor,
    required this.alertaTexto,
    required this.isAlertaPeligro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD6DBDB), // Gris claro de las tarjetas
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
              // Icono de la métrica
              Text(iconoPath, style: const TextStyle(fontSize: 10)),
              // Badge de alerta
              Column(
                children: [
                  Icon(
                    Icons.warning,
                    color: isAlertaPeligro ? Colors.red[900] : Colors.black,
                    size: 10,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alertaTexto,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
