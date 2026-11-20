import 'package:calidad_del_suelo/features/home/presentation/screens/menu_principal.dart';
import 'package:calidad_del_suelo/features/profile/perfil_usuario.dart';
import 'package:calidad_del_suelo/features/tracking/presentation/screens/mis_cultivos.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../weather/data/weather_service.dart';
import '../../../weather/domain/clima.dart';
import '../../../profile/configuracion_notificaciones.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/widgets/menu_inferior.dart';

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  ClimaCompleto? _clima;
  List<Map<String, dynamic>> _siembras = [];
  bool _cargando = true;

  bool _alertaLluvia = true;
  bool _alertaCalor = true;
  bool _alertaFrio = true;

  @override
  void initState() {
    super.initState();
    _cargarPreferenciasYCargarDatos();
  }

  Future<void> _cargarPreferenciasYCargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final servicio = WeatherService();
    final resultadoClima = await servicio.obtenerClima(
      WeatherService.defaultLat,
      WeatherService.defaultLon,
    );
    final siembrasDB = await DatabaseService.instance.obtenerSiembrasActivas();

    if (mounted) {
      setState(() {
        _alertaLluvia = prefs.getBool('alerta_lluvia') ?? true;
        _alertaCalor = prefs.getBool('alerta_calor') ?? true;
        _alertaFrio = prefs.getBool('alerta_frio') ?? true;
        _clima = resultadoClima;
        _siembras = siembrasDB;
        _cargando = false;
      });
    }
  }

  // Recarga solo preferencias al volver de Configuración en Perfil
  Future<void> _recargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _alertaLluvia = prefs.getBool('alerta_lluvia') ?? true;
        _alertaCalor = prefs.getBool('alerta_calor') ?? true;
        _alertaFrio = prefs.getBool('alerta_frio') ?? true;
      });
    }
  }

  List<Widget> _generarAlertas() {
    List<Widget> alertas = [];
    if (_clima == null) return alertas;

    // 1. Alertas meteorológicas generales
    for (var dia in _clima!.pronostico) {
      if (_alertaLluvia && dia.probabilidadLluvia > 70) {
        alertas.add(
          _tarjetaAlerta(
            titulo: 'Lluvia intensa esperada',
            mensaje:
                'El ${dia.fecha.day}/${dia.fecha.month} hay un ${dia.probabilidadLluvia.toStringAsFixed(0)}% de probabilidad de lluvia.',
            color: Colors.lightBlueAccent,
            icono: Icons.water_drop,
          ),
        );
      }
      if (_alertaCalor && dia.tempMax > 35) {
        alertas.add(
          _tarjetaAlerta(
            titulo: 'Calor extremo',
            mensaje:
                'Se esperan hasta ${dia.tempMax.toStringAsFixed(1)}°C el ${dia.fecha.day}/${dia.fecha.month}.',
            color: Colors.orangeAccent,
            icono: Icons.wb_sunny,
          ),
        );
      }
      if (_alertaFrio && dia.tempMin < 10) {
        alertas.add(
          _tarjetaAlerta(
            titulo: 'Frío intenso',
            mensaje:
                'Temperatura mínima de ${dia.tempMin.toStringAsFixed(1)}°C el ${dia.fecha.day}/${dia.fecha.month}.',
            color: Colors.cyanAccent,
            icono: Icons.ac_unit,
          ),
        );
      }
    }

    // 2. Alertas personalizadas por cultivo activo
    if (_clima!.pronostico.length > 1) {
      final manana = _clima!.pronostico[1];
      for (var siembra in _siembras) {
        final String nombreCultivo = siembra['crop_name'] ?? 'Cultivo';

        if (_alertaCalor && manana.tempMax > 32) {
          alertas.add(
            _tarjetaAlerta(
              titulo: 'Riesgo para $nombreCultivo',
              mensaje:
                  'Mañana se esperan ${manana.tempMax.toStringAsFixed(1)}°C. Tu $nombreCultivo podría sufrir estrés térmico.',
              color: Colors.amberAccent,
              icono: Icons.eco,
            ),
          );
        }
        if (_alertaLluvia && manana.probabilidadLluvia > 60) {
          alertas.add(
            _tarjetaAlerta(
              titulo: 'Lluvia y $nombreCultivo',
              mensaje:
                  'Hay ${manana.probabilidadLluvia.toStringAsFixed(0)}% de lluvia mañana. Revisa el drenaje de tu parcela.',
              color: Colors.tealAccent,
              icono: Icons.eco,
            ),
          );
        }
      }
    }

    return alertas;
  }

  Widget _tarjetaAlerta({
    required String titulo,
    required String mensaje,
    required Color color,
    required IconData icono,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF223521).withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.65), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mensaje,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final listaAlertas = _generarAlertas();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1E12),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            RutasImagenes.fondoCampo,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF0F1E12)),
          ),
          Container(color: Colors.black.withOpacity(0.50)),
          SafeArea(
            child: Column(
              children: [
                // Encabezado con acceso rápido a la configuración en Perfil
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Alertas y Clima',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Configurar alertas',
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ConfiguracionNotificaciones(),
                            ),
                          );
                          _recargarPreferencias();
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: _cargando
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.greenAccent,
                          ),
                        )
                      : _clima == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.cloud_off,
                                color: Colors.white54,
                                size: 48,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'No se pudo obtener el clima.\nVerifica tu conexión a internet.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() => _cargando = true);
                                  _cargarPreferenciasYCargarDatos();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF388E3C),
                                ),
                                child: const Text(
                                  'Reintentar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            top: 4,
                            bottom: 90,
                          ),
                          children: [
                            _construirTarjetaClima(),
                            const SizedBox(height: 20),
                            const Text(
                              'Alertas Automáticas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (listaAlertas.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF223521,
                                  ).withOpacity(0.92),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.greenAccent.withOpacity(0.45),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.greenAccent,
                                      size: 28,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Todo en orden',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'No se detectan condiciones extremas para tus cultivos en los próximos días.',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...listaAlertas,
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuInferior(
        indiceSeleccionado: 2,
        alSeleccionar: (index) {
          if (index == 2) {
            return;
          }
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuPrincipal()),
            );
          }
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MisCultivos()),
            );
          }
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PerfilUsuario()),
            );
          }
        },
      ),
    );
  }

  Widget _construirTarjetaClima() {
    final actual = _clima!.actual;
    final pronostico = _clima!.pronostico;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B3B22), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: Ubicación y fuente
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.greenAccent,
                size: 18,
              ),
              const SizedBox(width: 5),
              const Expanded(
                child: Text(
                  'Tizimín, Yuc.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                actual.fuente,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila central: Temperatura a la izquierda y detalles a la derecha (Responsiva)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bloque de temperatura (flexible para no empujar a la derecha)
              Flexible(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${actual.temperatura.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        'C',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Bloque derecho: Condiciones, humedad y viento
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Condiciones Actuales',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Humedad: ${actual.humedadAire.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Viento: ${actual.viento.toStringAsFixed(1)} km/h',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pronóstico horizontal de los próximos días
          SizedBox(
            height: 108,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pronostico.length,
              itemBuilder: (context, index) {
                final dia = pronostico[index];
                return Container(
                  width: 74,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        index == 0
                            ? 'Hoy'
                            : '${dia.fecha.day}/${dia.fecha.month}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      Icon(
                        dia.probabilidadLluvia > 50
                            ? Icons.water_drop
                            : Icons.wb_sunny,
                        color: dia.probabilidadLluvia > 50
                            ? Colors.lightBlueAccent
                            : Colors.amberAccent,
                        size: 22,
                      ),
                      Text(
                        '${dia.tempMax.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${dia.tempMin.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
