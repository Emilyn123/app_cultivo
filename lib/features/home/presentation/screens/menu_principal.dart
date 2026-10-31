import 'dart:ui';
import 'package:calidad_del_suelo/features/tracking/presentation/screens/panel_general_etapas.dart';
import 'package:flutter/material.dart';
import '../../../crops/presentation/screens/seleccion_cultivo.dart';
import '../../../monitor/presentation/screens/soil_diagnosis_screen.dart';
import '../../../tracking/presentation/screens/panel_general_etapas.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    // Obtenemos las medidas de la pantalla para hacer todo el diseño responsivo
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 1. Imagen de fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),

          // Filtro oscuro suave sobre el fondo
          Container(color: Colors.black.withOpacity(0.4)),

          // 2. Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                top: size.height * 0.02,
                bottom: 100.0,
              ),
              child: Column(
                children: [
                  // --- ENCABEZADO: Perfil y Notificaciones ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          Text(
                            'Hola, Agricultor',
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _IconoNotificacion(size: size.width * 0.07),
                          SizedBox(width: size.width * 0.02),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),

                  // --- TARJETA 1: Seguimiento (Información extra eliminada) ---
                  _TarjetaMenuCristalVerde(
                    titulo: 'Seguimiento',
                    iconoTitulo: Icons.analytics_outlined,
                    descripcion:
                        'Monitorea el estado, salud y crecimiento de tus cultivos.',
                    textoBoton: 'Ver mis cultivos',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PanelGeneralEtapas(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  // --- TARJETA 2: Nuevo Cultivo (Información extra eliminada) ---
                  _TarjetaMenuCristalVerde(
                    titulo: 'Nuevo Cultivo',
                    iconoTitulo: Icons.eco_outlined,
                    descripcion:
                        'Inicia nuevo ciclo de siembra.\nRegistra datos y planifica tu temporada.',
                    textoBoton: 'Añadir Cultivo',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SeleccionCultivo(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                const begin = Offset(
                                  0.0,
                                  1.0,
                                ); // 1.0 significa que empieza abajo de la pantalla
                                const end = Offset.zero; // Termina en el centro
                                const curve = Curves.easeOutCubic;

                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  // --- TARJETA 3: Recomendaciones (Conserva los íconos) ---
                  _TarjetaMenuCristalVerde(
                    titulo: 'Recomendaciones',
                    iconoTitulo: Icons.help_outline,
                    descripcion:
                        'No tienes ideas de que cultivar ten estas opciones dependiendo de los parametros de tu suelo.',
                    infoExtra: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ),
                    textoBoton: 'Elegir cultivo',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SoilDiagnosisScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- MENÚ INFERIOR (Bottom Navigation Bar) ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B3B22).withOpacity(0.85),
          border: const Border(
            top: BorderSide(color: Colors.white24, width: 0.5),
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              currentIndex: _indiceSeleccionado,
              onTap: (index) {
                setState(() {
                  _indiceSeleccionado = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Inicio',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: 'Mis Cultivos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined),
                  label: 'Alertas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Perfil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// WIDGETS REUTILIZABLES (Diseño Responsivo)
// =====================================================================

// --- WIDGET PARA LAS TARJETAS (Efecto Cristal + Verde Oscuro) ---
class _TarjetaMenuCristalVerde extends StatelessWidget {
  final String titulo;
  final IconData iconoTitulo;
  final String descripcion;
  final Widget? infoExtra; // Ahora es opcional (puede ser null)
  final String textoBoton;
  final VoidCallback alPresionar;

  const _TarjetaMenuCristalVerde({
    required this.titulo,
    required this.iconoTitulo,
    required this.descripcion,
    this.infoExtra, // Se quitó el required
    required this.textoBoton,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(width * 0.05),
          decoration: BoxDecoration(
            color: const Color(0xFF1B3B22).withOpacity(0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconoTitulo, color: Colors.white, size: width * 0.07),
                  SizedBox(width: width * 0.02),
                  Flexible(
                    child: Text(
                      titulo,
                      style: TextStyle(
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: width * 0.035),
              ),

              // Solo dibuja infoExtra si le mandamos datos (como en la tarjeta 3)
              if (infoExtra != null) infoExtra!,
              if (infoExtra == null)
                const SizedBox(height: 15), // Espacio extra si no hay info

              const SizedBox(height: 10),
              SizedBox(
                width: width * 0.6,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF388E3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: alPresionar,
                  child: FittedBox(
                    child: Text(
                      textoBoton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET PARA LAS CAMPANITAS CON PUNTO ROJO ---
class _IconoNotificacion extends StatelessWidget {
  final double size;
  const _IconoNotificacion({required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(Icons.notifications_none, color: Colors.white, size: size),
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.deepOrange, // Punto naranja/rojo
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
          ),
        ),
      ],
    );
  }
}
