import 'package:flutter/material.dart';
import 'iniciar_sesion.dart';
import '../../../../core/widgets/titulo_tul_luum.dart';

class InicioAnimado extends StatefulWidget {
  const InicioAnimado({super.key});

  @override
  State<InicioAnimado> createState() => _InicioAnimadoState();
}

class _InicioAnimadoState extends State<InicioAnimado>
    with SingleTickerProviderStateMixin {
  late AnimationController _controladorDeAnimacion;
  late Animation<double> _animacionAparecer;
  late Animation<Offset> _animacionSubir;
  late Animation<Offset> _animacionBajar;

  @override
  void initState() {
    super.initState();

    _controladorDeAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animacionAparecer = CurvedAnimation(
      parent: _controladorDeAnimacion,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    _animacionSubir =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controladorDeAnimacion,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animacionBajar =
        Tween<Offset>(begin: const Offset(0.0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controladorDeAnimacion,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
          ),
        );

    _controladorDeAnimacion.forward();
  }

  @override
  void dispose() {
    _controladorDeAnimacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tomamos las medidas exactas de la pantalla para hacer los espacios proporcionales
    final altoPantalla = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // CAPA 1: Imagen de fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),

          // CAPA 2: Contenido
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AnimatedBuilder(
                    animation: _controladorDeAnimacion,
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // --- 1. Logo superior ---
                          SlideTransition(
                            position: _animacionBajar,
                            child: FadeTransition(
                              opacity: _controladorDeAnimacion,
                              child: Image.asset(
                                'assets/images/logo_superior.png',
                                height:
                                    altoPantalla *
                                    0.12, // Altura relativa a la pantalla (12%)
                              ),
                            ),
                          ),
                          SizedBox(height: altoPantalla * 0.02),

                          // --- 2. Títulos con FittedBox para hacerlos responsivos ---
                          FadeTransition(
                            opacity: _animacionAparecer,
                            child: Column(
                              children: [
                                // Título principal (NUEVO NOMBRE)
                                const TituloTulLuum(),

                                SizedBox(height: altoPantalla * 0.02),

                                // Subtítulo (CON CAJA SEMITRANSPARENTE PARA QUE NO SE PIERDA)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(
                                      128,
                                    ), // Fondo oscurecido al 50%
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ), // Bordes redondeados
                                  ),
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Tu aliada para un suelo\nsaludable y fértil',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Colors.white, // Letra blanca pura
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: altoPantalla * 0.04),

                          // --- 3. Tarjeta central y Botón ---
                          SlideTransition(
                            position: _animacionSubir,
                            child: FadeTransition(
                              opacity: _animacionAparecer,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(76),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        'assets/images/logo_cuadrado.png',
                                        height:
                                            altoPantalla *
                                            0.15, // Altura al 15% de la pantalla
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // --- CAMBIO AQUÍ PARA NO REPETIR ---
                                  const Text(
                                    'MONITOREO DE CALIDAD DEL SUELO', // Descripción en vez de repetir el nombre
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: altoPantalla * 0.04),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF2E7D32,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          side: const BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const IniciarSesion(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Comenzar',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Contáctanos',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
