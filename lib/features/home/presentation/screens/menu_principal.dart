import 'dart:ui';
import 'dart:io';
import 'package:calidad_del_suelo/features/monitor/presentation/screens/registro_lote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calidad_del_suelo/features/profile/perfil_usuario.dart';
import 'package:calidad_del_suelo/features/tracking/presentation/screens/mis_cultivos.dart';
import 'package:flutter/material.dart';
import '../../../crops/presentation/screens/seleccion_cultivo.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/widgets/menu_inferior.dart';
import '../../../plagas/presentation/screens/bitacora_plagas_screen.dart';
import '../../../fertilizacion/presentation/screens/bitacora_fertilizacion_screen.dart';
import '../../../alertas/presentation/screens/alertas_screen.dart';
import '../../../reports/presentation/screens/exportar_reporte_screen.dart';
import '../../../alertas/domain/alertas_service.dart';
import '../../../alertas/presentation/screens/alertas_screen.dart';
import '../../../weather/data/weather_service.dart';
import '../../../weather/domain/clima.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  //int _indiceSeleccionado = 0;
  int _totalAlertas = 0;

  String _nombreUsuario = 'Cargando...';
  File? _imagenPerfil;

  @override
  void initState() {
    super.initState();
    _cargarDatosPerfil();
    _cargarConteoAlertas();
  }

  Future<void> _cargarConteoAlertas() async {
    try {
      ClimaCompleto? clima;
      try {
        clima = await WeatherService().obtenerClima(
          WeatherService.defaultLat,
          WeatherService.defaultLon,
        );
      } catch (_) {
        clima = null;
      }

      final siembras = await DatabaseService.instance.obtenerSiembrasActivas();
      final alertas = await AlertasService.generarTodas(
        clima: clima,
        siembras: siembras,
      );

      if (mounted) {
        setState(() => _totalAlertas = alertas.length);
      }
    } catch (_) {}
  }

  Future<void> _cargarDatosPerfil() async {
    // 1. Obtener el nombre desde SQLite (Offline)
    final datos = await DatabaseService.instance.obtenerDatosSesion();
    String nombre = 'Agricultor';

    if (datos != null && datos['nombre_completo'] != null) {
      // split(' ')[0] extrae únicamente la primera palabra (el primer nombre)
      nombre = datos['nombre_completo'].toString().split(' ')[0];
    }

    // 2. Obtener la ruta de la foto guardada en el Perfil
    final prefs = await SharedPreferences.getInstance();
    final rutaFoto = prefs.getString('ruta_foto_perfil');
    File? imagen;

    if (rutaFoto != null && File(rutaFoto).existsSync()) {
      imagen = File(rutaFoto);
    }

    if (mounted) {
      setState(() {
        _nombreUsuario = nombre;
        _imagenPerfil = imagen;
      });
    }
  }

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
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white24,
                            backgroundImage: _imagenPerfil != null
                                ? FileImage(_imagenPerfil!)
                                : null,
                            // Muestra el ícono solo si no hay imagen
                            child: _imagenPerfil == null
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : null,
                          ),
                          SizedBox(width: size.width * 0.03),
                          Text(
                            'Hola, $_nombreUsuario',
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
                          _IconoNotificacion(
                            size: size.width * 0.075,
                            cantidad: _totalAlertas,
                            alPresionar: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AlertasScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: size.width * 0.02),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
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
                          builder: (context) => const MisCultivos(),
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
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ),
                    textoBoton: 'Ingresa Tus Parametros',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RegistroLoteScreen(idCultivoEsperado: 0),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.03),

                  // --- TARJETA 4: Bitácora de Plagas (Nueva) ---
                  _TarjetaMenuCristalVerde(
                    titulo: 'Bitácora de Plagas',
                    iconoTitulo: Icons.bug_report_outlined, // Ícono de insecto
                    descripcion:
                        'Identifica plagas comunes, revisa sus causas y mantén un registro visual de tu cultivo.',
                    textoBoton: 'Ver Catalogo',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BitacoraPlagasScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  // ---TARJETA 5: Fertilizacion foliar
                  _TarjetaMenuCristalVerde(
                    titulo: 'Fertilización Foliar',
                    iconoTitulo: Icons.science_outlined,
                    descripcion:
                        'Lleva un control de los fertilizantes y humus aplicados, con fecha y cantidades.',
                    textoBoton: 'Abrir Bitácora',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BitacoraFertilizacionScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExportarReporteScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text(
                      'Exportar Reporte PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- MENÚ INFERIOR (Bottom Navigation Bar) ---
      bottomNavigationBar: MenuInferior(
        indiceSeleccionado: 0,
        alSeleccionar: (index) {
          if (index == 0) {
            return;
          }
          if (index == 1) {
            // Navegar a la pantalla de Mis Cultivos (Panel General)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MisCultivos()),
            );
          }
          if (index == 2) {
            // Navegar a la pantalla de Alertas (cuando la crees)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AlertasScreen()),
            );
          }
          if (index == 3) {
            // Navegar a la pantalla de Perfil (cuando la crees)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PerfilUsuario()),
            );
          }
        },
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
  final int cantidad;
  final VoidCallback alPresionar;
  const _IconoNotificacion({
    required this.size,
    required this.cantidad,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alPresionar,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            cantidad > 0
                ? Icons.notifications_active_outlined
                : Icons.notifications_none,
            color: Colors.white,
            size: size,
          ),
          if (cantidad > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF0F1E12),
                    width: 1.2,
                  ),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  cantidad > 9 ? '9+' : '$cantidad',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
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
