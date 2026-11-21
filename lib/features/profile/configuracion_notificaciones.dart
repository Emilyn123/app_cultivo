import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';

class ConfiguracionNotificaciones extends StatefulWidget {
  const ConfiguracionNotificaciones({super.key});

  @override
  State<ConfiguracionNotificaciones> createState() =>
      _ConfiguracionNotificacionesState();
}

class _ConfiguracionNotificacionesState
    extends State<ConfiguracionNotificaciones> {
  bool _alertaLluvia = true;
  bool _alertaCalor = true;
  bool _alertaFrio = true;
  bool _cargando = true;
  bool _alertaClimaDiario = true;
  bool _alertaRecordatorioEtapa = true;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _alertaLluvia = prefs.getBool('alerta_lluvia') ?? true;
        _alertaCalor = prefs.getBool('alerta_calor') ?? true;
        _alertaFrio = prefs.getBool('alerta_frio') ?? true;
        _alertaClimaDiario = prefs.getBool('alerta_clima_diario') ?? true;
        _alertaRecordatorioEtapa =
            prefs.getBool('alerta_recordatorio_etapa') ?? true;
        _cargando = false;
      });
    }
  }

  Future<void> _guardarPreferencia(String clave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(clave, valor);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.greenAccent),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: 12.0,
                        ),
                        child: const EncabezadoPersonalizado(
                          titulo: 'Configurar Alertas',
                        ),
                      ),
                      //scroll
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            top: 8.0,
                            bottom: 24.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF223521).withOpacity(0.92),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SwitchListTile(
                                  secondary: const Icon(
                                    Icons.water_drop,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  title: const Text(
                                    'Alertas de Lluvia',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Avisar si hay alta probabilidad de lluvia',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  activeThumbColor: Colors.greenAccent,
                                  value: _alertaLluvia,
                                  onChanged: (val) {
                                    setState(() => _alertaLluvia = val);
                                    _guardarPreferencia('alerta_lluvia', val);
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.12),
                                ),
                                SwitchListTile(
                                  secondary: const Icon(
                                    Icons.wb_sunny,
                                    color: Colors.orangeAccent,
                                  ),
                                  title: const Text(
                                    'Alertas de Calor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Avisar si la temperatura es muy alta',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  activeThumbColor: Colors.greenAccent,
                                  value: _alertaCalor,
                                  onChanged: (val) {
                                    setState(() => _alertaCalor = val);
                                    _guardarPreferencia('alerta_calor', val);
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.12),
                                ),
                                SwitchListTile(
                                  secondary: const Icon(
                                    Icons.ac_unit,
                                    color: Colors.cyanAccent,
                                  ),
                                  title: const Text(
                                    'Alertas de Frío',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Avisar si hay descenso brusco de temperatura',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  activeThumbColor: Colors.greenAccent,
                                  value: _alertaFrio,
                                  onChanged: (val) {
                                    setState(() => _alertaFrio = val);
                                    _guardarPreferencia('alerta_frio', val);
                                  },
                                ),
                                // 3. Dentro del Column de tus SwitchListTile (debajo del switch de Frío), agrega:
                                Divider(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.12),
                                ),
                                SwitchListTile(
                                  secondary: const Icon(
                                    Icons.today_rounded,
                                    color: Colors.amberAccent,
                                  ),
                                  title: const Text(
                                    'Resumen y Clima Diario',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Avisos de viento, humedad ambiental y condiciones de hoy',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  activeThumbColor: Colors.greenAccent,
                                  value: _alertaClimaDiario,
                                  onChanged: (val) {
                                    setState(() => _alertaClimaDiario = val);
                                    _guardarPreferencia(
                                      'alerta_clima_diario',
                                      val,
                                    );
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.12),
                                ),
                                SwitchListTile(
                                  secondary: const Icon(
                                    Icons.notifications_active,
                                    color: Colors.greenAccent,
                                  ),
                                  title: const Text(
                                    'Recordatorios de Etapa',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Recordar revisar parámetros del suelo al cambiar de etapa',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                  activeThumbColor: Colors.greenAccent,
                                  value: _alertaRecordatorioEtapa,
                                  onChanged: (val) {
                                    setState(
                                      () => _alertaRecordatorioEtapa = val,
                                    );
                                    _guardarPreferencia(
                                      'alerta_recordatorio_etapa',
                                      val,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
