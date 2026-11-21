import 'package:flutter/material.dart';
import '../../domain/alertas_service.dart';
import '../../../weather/data/weather_service.dart';
import '../../../weather/domain/clima.dart';
import '../../../profile/configuracion_notificaciones.dart';
import '../../../home/presentation/screens/menu_principal.dart';
import '../../../tracking/presentation/screens/mis_cultivos.dart';
import '../../../profile/perfil_usuario.dart';
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
  List<AlertaItem> _alertas = [];
  bool _cargando = true;
  final int _indiceMenu = 2;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  /// Carga clima, siembras locales y genera todas las alertas desde el servicio compartido
  Future<void> _cargarDatos() async {
    ClimaCompleto? resultadoClima;
    try {
      resultadoClima = await WeatherService().obtenerClima(
        WeatherService.defaultLat,
        WeatherService.defaultLon,
      );
    } catch (_) {
      resultadoClima = null;
    }

    final siembrasDB = await DatabaseService.instance.obtenerSiembrasActivas();
    final alertasGeneradas = await AlertasService.generarTodas(
      clima: resultadoClima,
      siembras: siembrasDB,
    );

    if (mounted) {
      setState(() {
        _clima = resultadoClima;
        _siembras = siembrasDB;
        _alertas = alertasGeneradas;
        _cargando = false;
      });
    }
  }

  /// Recalcula solo las alertas al volver de Configuración (sin volver a consultar la API)
  Future<void> _recargarPreferencias() async {
    final alertasGeneradas = await AlertasService.generarTodas(
      clima: _clima,
      siembras: _siembras,
    );

    if (mounted) {
      setState(() {
        _alertas = alertasGeneradas;
      });
    }
  }

  Widget _tarjetaAlerta(AlertaItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF223521).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.color.withValues(alpha: 0.65),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icono, color: item.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: item.color,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.mensaje,
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

    final recordatoriosEtapa = _alertas
        .where((a) => a.categoria == CategoriaAlerta.etapa)
        .toList();
    final alertasDiarias = _alertas
        .where((a) => a.categoria == CategoriaAlerta.climaHoy)
        .toList();
    final alertasPronostico = _alertas
        .where((a) => a.categoria == CategoriaAlerta.pronostico)
        .toList();

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
          Container(color: Colors.black.withValues(alpha: 0.50)),
          SafeArea(
            child: Column(
              children: [
                // Encabezado con acceso rápido a Configuración de Alertas
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
                      : RefreshIndicator(
                          color: Colors.greenAccent,
                          backgroundColor: const Color(0xFF1B3B22),
                          onRefresh: _cargarDatos,
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: EdgeInsets.only(
                              left: size.width * 0.05,
                              right: size.width * 0.05,
                              top: 4,
                              bottom: 90,
                            ),
                            children: [
                              // Tarjeta de clima o aviso offline con botón de reintento
                              if (_clima != null)
                                _construirTarjetaClima()
                              else
                                _construirAvisoSinClima(),

                              // 1. Recordatorios de etapas (funcionan incluso sin internet)
                              if (recordatoriosEtapa.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Recordatorios de Etapas',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...recordatoriosEtapa.map(_tarjetaAlerta),
                              ],

                              // 2. Clima de hoy
                              if (alertasDiarias.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Clima de Hoy',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...alertasDiarias.map(_tarjetaAlerta),
                              ],

                              // 3. Alertas de pronóstico y cultivos
                              if (alertasPronostico.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Alertas de Pronóstico',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...alertasPronostico.map(_tarjetaAlerta),
                              ],

                              // Estado vacío cuando no hay ninguna alerta activa
                              if (_alertas.isEmpty) ...[
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF223521,
                                    ).withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.greenAccent.withValues(
                                        alpha: 0.45,
                                      ),
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
                                              'No hay alertas ni cambios de etapa pendientes en este momento.',
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
                                ),
                              ],
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuInferior(
        indiceSeleccionado: _indiceMenu,
        alSeleccionar: (index) {
          if (index == _indiceMenu) return;
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MenuPrincipal()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MisCultivos()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PerfilUsuario()),
            );
          }
        },
      ),
    );
  }

  Widget _construirAvisoSinClima() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF223521).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: Colors.white54, size: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Sin conexión para el clima.\nTus recordatorios locales siguen activos.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() => _cargando = true);
              _cargarDatos();
            },
            child: const Text(
              'Reintentar',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.greenAccent,
                size: 18,
              ),
              const SizedBox(width: 5),
              const Text(
                'Tizimín, Yuc.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                actual.fuente,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
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
                          fontSize: 54,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
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
                    Text(
                      'Humedad: ${actual.humedadAire.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      'Viento: ${actual.viento.toStringAsFixed(1)} km/h',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
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
