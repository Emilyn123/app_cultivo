import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../weather/domain/clima.dart';

enum CategoriaAlerta { etapa, climaHoy, pronostico }

class AlertaItem {
  final String titulo;
  final String mensaje;
  final Color color;
  final IconData icono;
  final CategoriaAlerta categoria;

  const AlertaItem({
    required this.titulo,
    required this.mensaje,
    required this.color,
    required this.icono,
    required this.categoria,
  });
}

class AlertasService {
  static const List<String> nombresEtapas = [
    'Siembra',
    'Germinación',
    'Crecimiento',
    'Amarre',
    'Maduración',
  ];

  static List<int> diasPorEtapa(String nombreCultivo) {
    final nombre = nombreCultivo.toUpperCase();
    if (nombre.contains('TOMATE')) return [0, 7, 20, 45, 70];
    if (nombre.contains('FRIJOL')) return [0, 5, 15, 35, 60];
    if (nombre.contains('CILANTRO')) return [0, 7, 18, 30, 45];
    if (nombre.contains('RABANO') || nombre.contains('RÁBANO')) {
      return [0, 4, 10, 18, 25];
    }
    return [0, 7, 20, 40, 60];
  }

  /// Genera todas las alertas activas respetando los switches de Configuración
  static Future<List<AlertaItem>> generarTodas({
    required ClimaCompleto? clima,
    required List<Map<String, dynamic>> siembras,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final alertaLluvia = prefs.getBool('alerta_lluvia') ?? true;
    final alertaCalor = prefs.getBool('alerta_calor') ?? true;
    final alertaFrio = prefs.getBool('alerta_frio') ?? true;
    final alertaClimaDiario = prefs.getBool('alerta_clima_diario') ?? true;
    final alertaRecordatorioEtapa =
        prefs.getBool('alerta_recordatorio_etapa') ?? true;

    final List<AlertaItem> resultado = [];

    // 1. RECORDATORIOS DE ETAPA
    if (alertaRecordatorioEtapa) {
      for (final siembra in siembras) {
        final cultivo = siembra['crop_name']?.toString() ?? 'Cultivo';
        final lote = siembra['nombre_lote']?.toString() ?? 'Tu parcela';
        final etapaActual = (siembra['current_stage'] as int?) ?? 1;
        final fechaInicio = DateTime.tryParse(
          siembra['started_at']?.toString() ?? '',
        );
        if (fechaInicio == null) continue;

        final dias = DateTime.now().difference(fechaInicio).inDays;
        final calendario = diasPorEtapa(cultivo);

        int etapaEsperada = 1;
        for (int i = 0; i < calendario.length; i++) {
          if (dias >= calendario[i]) etapaEsperada = i + 1;
        }

        if (etapaEsperada > etapaActual && etapaEsperada <= 5) {
          final nuevaEtapa = nombresEtapas[etapaEsperada - 1];
          resultado.add(
            AlertaItem(
              titulo: 'Nueva etapa: $cultivo ($lote)',
              mensaje:
                  'Lleva $dias días desde la siembra. Ya debería estar en $nuevaEtapa. Verifica los parámetros del suelo en "Mis Cultivos".',
              color: Colors.greenAccent,
              icono: Icons.assignment_turned_in_rounded,
              categoria: CategoriaAlerta.etapa,
            ),
          );
        } else if (etapaActual < 5) {
          final faltan = calendario[etapaActual] - dias;
          if (faltan > 0 && faltan <= 2) {
            resultado.add(
              AlertaItem(
                titulo: 'Próximo cambio de etapa: $cultivo',
                mensaje:
                    'En $faltan día(s) tu parcela "$lote" pasará a ${nombresEtapas[etapaActual]}. Prepara tu medición de pH, CE, temperatura y humedad.',
                color: Colors.lightGreenAccent,
                icono: Icons.schedule_rounded,
                categoria: CategoriaAlerta.etapa,
              ),
            );
          } else if (dias > 0 && dias % 7 == 0) {
            resultado.add(
              AlertaItem(
                titulo: 'Chequeo semanal: $cultivo ($lote)',
                mensaje:
                    'Cumples $dias días de cultivo. Registra una lectura del suelo para confirmar que sigue en rango óptimo.',
                color: Colors.tealAccent,
                icono: Icons.fact_check_outlined,
                categoria: CategoriaAlerta.etapa,
              ),
            );
          }
        }
      }
    }

    if (clima == null) return resultado;

    // 2. CLIMA DE HOY
    if (alertaClimaDiario) {
      final actual = clima.actual;
      final hoy = clima.pronostico.isNotEmpty ? clima.pronostico.first : null;

      if (actual.viento > 20) {
        resultado.add(
          AlertaItem(
            titulo:
                'Viento fuerte hoy (${actual.viento.toStringAsFixed(1)} km/h)',
            mensaje:
                'Evita fertilización foliar o fumigaciones hoy para que el viento no disperse el producto.',
            color: Colors.blueGrey.shade200,
            icono: Icons.air_rounded,
            categoria: CategoriaAlerta.climaHoy,
          ),
        );
      }

      if (actual.humedadAire < 45) {
        resultado.add(
          AlertaItem(
            titulo:
                'Ambiente seco hoy (${actual.humedadAire.toStringAsFixed(0)}%)',
            mensaje:
                'La evaporación del suelo será rápida. Revisa la humedad de tus parcelas por la tarde.',
            color: Colors.orangeAccent,
            icono: Icons.opacity_rounded,
            categoria: CategoriaAlerta.climaHoy,
          ),
        );
      } else if (actual.humedadAire > 85) {
        resultado.add(
          AlertaItem(
            titulo:
                'Humedad ambiental alta (${actual.humedadAire.toStringAsFixed(0)}%)',
            mensaje:
                'Condición favorable para hongos y plagas foliares. Vigila las hojas de tus cultivos.',
            color: Colors.cyanAccent,
            icono: Icons.water_rounded,
            categoria: CategoriaAlerta.climaHoy,
          ),
        );
      }

      if (hoy != null) {
        if (hoy.probabilidadLluvia >= 40) {
          resultado.add(
            AlertaItem(
              titulo:
                  'Clima de hoy: Posible lluvia (${hoy.probabilidadLluvia.toStringAsFixed(0)}%)',
              mensaje:
                  'Entre ${hoy.tempMin.toStringAsFixed(0)}°C y ${hoy.tempMax.toStringAsFixed(0)}°C. Considera ajustar el riego.',
              color: Colors.lightBlueAccent,
              icono: Icons.umbrella_rounded,
              categoria: CategoriaAlerta.climaHoy,
            ),
          );
        } else if (hoy.tempMax >= 33) {
          resultado.add(
            AlertaItem(
              titulo:
                  'Clima de hoy: Día caluroso (${hoy.tempMax.toStringAsFixed(0)}°C)',
              mensaje:
                  'Riega temprano o al atardecer para evitar estrés térmico en las plantas.',
              color: Colors.amberAccent,
              icono: Icons.wb_sunny_rounded,
              categoria: CategoriaAlerta.climaHoy,
            ),
          );
        } else {
          resultado.add(
            AlertaItem(
              titulo: 'Clima de hoy: Condiciones favorables',
              mensaje:
                  'Máxima de ${hoy.tempMax.toStringAsFixed(0)}°C y baja probabilidad de lluvia. Buen día para labores de campo.',
              color: Colors.greenAccent,
              icono: Icons.check_circle_outline,
              categoria: CategoriaAlerta.climaHoy,
            ),
          );
        }
      }
    }

    // 3. PRONÓSTICO 7 DÍAS Y RIESGOS POR CULTIVO
    for (final dia in clima.pronostico) {
      if (alertaLluvia && dia.probabilidadLluvia > 70) {
        resultado.add(
          AlertaItem(
            titulo: 'Lluvia intensa esperada',
            mensaje:
                'El ${dia.fecha.day}/${dia.fecha.month} hay ${dia.probabilidadLluvia.toStringAsFixed(0)}% de probabilidad de lluvia.',
            color: Colors.lightBlueAccent,
            icono: Icons.water_drop,
            categoria: CategoriaAlerta.pronostico,
          ),
        );
      }
      if (alertaCalor && dia.tempMax > 35) {
        resultado.add(
          AlertaItem(
            titulo: 'Calor extremo',
            mensaje:
                'Se esperan hasta ${dia.tempMax.toStringAsFixed(1)}°C el ${dia.fecha.day}/${dia.fecha.month}.',
            color: Colors.orangeAccent,
            icono: Icons.wb_sunny,
            categoria: CategoriaAlerta.pronostico,
          ),
        );
      }
      if (alertaFrio && dia.tempMin < 10) {
        resultado.add(
          AlertaItem(
            titulo: 'Frío intenso',
            mensaje:
                'Temperatura mínima de ${dia.tempMin.toStringAsFixed(1)}°C el ${dia.fecha.day}/${dia.fecha.month}.',
            color: Colors.cyanAccent,
            icono: Icons.ac_unit,
            categoria: CategoriaAlerta.pronostico,
          ),
        );
      }
    }

    if (clima.pronostico.length > 1) {
      final manana = clima.pronostico[1];
      for (final siembra in siembras) {
        final nombreCultivo = siembra['crop_name']?.toString() ?? 'Cultivo';
        if (alertaCalor && manana.tempMax > 32) {
          resultado.add(
            AlertaItem(
              titulo: 'Riesgo para $nombreCultivo',
              mensaje:
                  'Mañana se esperan ${manana.tempMax.toStringAsFixed(1)}°C. Tu $nombreCultivo podría sufrir estrés térmico.',
              color: Colors.amberAccent,
              icono: Icons.eco,
              categoria: CategoriaAlerta.pronostico,
            ),
          );
        }
        if (alertaLluvia && manana.probabilidadLluvia > 60) {
          resultado.add(
            AlertaItem(
              titulo: 'Lluvia y $nombreCultivo',
              mensaje:
                  'Hay ${manana.probabilidadLluvia.toStringAsFixed(0)}% de lluvia mañana. Revisa el drenaje de tu parcela.',
              color: Colors.tealAccent,
              icono: Icons.eco,
              categoria: CategoriaAlerta.pronostico,
            ),
          );
        }
      }
    }

    return resultado;
  }
}
