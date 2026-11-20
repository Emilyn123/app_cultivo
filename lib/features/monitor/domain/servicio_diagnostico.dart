// lib/features/monitor/domain/servicio_diagnostico.dart

class ResultadoDiagnostico {
  final bool esApto;
  final List<String> mensajesAlerta;

  // Banderas individuales para saber qué cubo pintar de rojo
  final bool tempOk;
  final bool humedadOk;
  final bool phOk;
  final bool ceOk;

  ResultadoDiagnostico({
    required this.esApto,
    required this.mensajesAlerta,
    required this.tempOk,
    required this.humedadOk,
    required this.phOk,
    required this.ceOk,
  });
}

class ServicioDiagnostico {
  // ==========================================================
  // CATÁLOGO CENTRALIZADO (Textos Visuales + Valores Matemáticos)
  // ==========================================================
  static List<Map<String, dynamic>> obtenerCatalogoCultivos() {
    return [
      {
        'id_cultivo': 1,
        'nombre': 'TOMATE ROJO',
        'imagenPath': 'assets/images/tomate_rojo.png',
        'iconoPath': 'assets/images/comparacion/icono_tomate.png',
        'ph': '6.00 - 6.80',
        'ce': '1.00 a 1.50 dS/m',
        'temp': '11.00 a 34.00°C',
        'hum': '65.00 - 85.00%',
        // Variables crudas para el Cerebro Matemático
        'minTemp': 11.0, 'maxTemp': 34.0,
        'minHum': 65.0, 'maxHum': 85.0,
        'minPh': 6.0, 'maxPh': 6.8,
        'minCe': 1.0, 'maxCe': 1.5,
      },
      {
        'id_cultivo': 2,
        'nombre': 'FRIJOL',
        'imagenPath': 'assets/images/frijol.png',
        'iconoPath': 'assets/images/comparacion/icono_frijol.png',
        'ph': '6.00 - 6.80',
        'ce': '0.80 a 1.00 dS/m',
        'temp': '10.00 a 15.00°C',
        'hum': '55.00 - 75.00%',
        'minTemp': 10.0,
        'maxTemp': 15.0,
        'minHum': 55.0,
        'maxHum': 75.0,
        'minPh': 6.0,
        'maxPh': 6.8,
        'minCe': 0.8,
        'maxCe': 1.0,
      },
      {
        'id_cultivo': 3,
        'nombre': 'CILANTRO',
        'imagenPath': 'assets/images/cilantro.png',
        'iconoPath': 'assets/images/comparacion/icono_cilantro.png',
        'ph': '5.50 - 6.80',
        'ce': '0.80 a 1.20 dS/m',
        'temp': '18.00 a 25.00°C',
        'hum': '70.00 - 90.00%',
        'minTemp': 18.0,
        'maxTemp': 25.0,
        'minHum': 70.0,
        'maxHum': 90.0,
        'minPh': 5.5,
        'maxPh': 6.8,
        'minCe': 0.8,
        'maxCe': 1.2,
      },
      {
        'id_cultivo': 4,
        'nombre': 'RABANO',
        'imagenPath': 'assets/images/rabano.png',
        'iconoPath': 'assets/images/comparacion/icono_rabano.png',
        'ph': '5.50 - 6.80',
        'ce': '0.80 a 1.20 dS/m',
        'temp': '15.00 a 22.00°C',
        'hum': '70.00 - 90.00%',
        'minTemp': 15.0,
        'maxTemp': 22.0,
        'minHum': 70.0,
        'maxHum': 90.0,
        'minPh': 5.5,
        'maxPh': 6.8,
        'minCe': 0.8,
        'maxCe': 1.2,
      },
    ];
  }

  // ==========================================================
  // EVALUACIÓN (Alerta Verde o Roja)
  // ==========================================================
  static ResultadoDiagnostico evaluarSuelo({
    required int idCultivo,
    required double temp,
    required double humedad,
    required double ph,
    required double ce,
  }) {
    // 1. Rescatamos todo desde el catálogo
    final catalogo = obtenerCatalogoCultivos();
    final planta = catalogo.firstWhere(
      (c) => c['id_cultivo'] == idCultivo,
      orElse: () => catalogo.first,
    );

    // 2. Evaluamos usando los valores del catálogo
    bool tempOk = temp >= planta['minTemp'] && temp <= planta['maxTemp'];
    bool humedadOk = humedad >= planta['minHum'] && humedad <= planta['maxHum'];
    bool phOk = ph >= planta['minPh'] && ph <= planta['maxPh'];
    bool ceOk = ce >= planta['minCe'] && ce <= planta['maxCe'];

    List<String> alertas = [];
    if (!tempOk) {
      alertas.add(
        temp > planta['maxTemp'] ? 'Estrés por calor' : 'Temperatura baja',
      );
    }
    if (!humedadOk) {
      alertas.add(
        humedad < planta['minHum'] ? 'Suelo muy seco' : 'Exceso de humedad',
      );
    }
    if (!phOk) {
      alertas.add(
        ph < planta['minPh']
            ? 'Suelo demasiado ácido'
            : 'Suelo demasiado alcalino',
      );
    }
    if (!ceOk) {
      alertas.add(
        ce > planta['maxCe'] ? 'Alta salinidad' : 'Baja conductividad',
      );
    }

    return ResultadoDiagnostico(
      esApto: alertas.isEmpty,
      mensajesAlerta: alertas,
      tempOk: tempOk,
      humedadOk: humedadOk,
      phOk: phOk,
      ceOk: ceOk,
    );
  }

  // ==========================================================
  // MOTOR DE INTELIGENCIA DE NEGOCIOS (SCORING)
  // ==========================================================
  static double _calcularAfinidad(
    Map<String, dynamic> planta,
    double temp,
    double humedad,
    double ph,
    double ce,
  ) {
    double puntuar(double valor, double min, double max) {
      double centro = (min + max) / 2;
      double tolerancia = (max - min) / 2;
      if (tolerancia == 0) return 100.0;

      double desviacion = (valor - centro).abs();
      double porcentaje = 1 - (desviacion / tolerancia);

      return 50 + (porcentaje * 50);
    }

    // Calculamos directamente con los rangos inyectados en la planta
    double scoreTemp = puntuar(temp, planta['minTemp'], planta['maxTemp']);
    double scoreHum = puntuar(humedad, planta['minHum'], planta['maxHum']);
    double scorePh = puntuar(ph, planta['minPh'], planta['maxPh']);
    double scoreCe = puntuar(ce, planta['minCe'], planta['maxCe']);

    return (scoreTemp + scoreHum + scorePh + scoreCe) / 4;
  }

  static String _generarMotivo(String nombreCultivo, double score) {
    if (score >= 90) {
      return 'El $nombreCultivo es tu mejor opción (Afinidad: ${score.toStringAsFixed(1)}%). Tus parámetros están en el centro absoluto de sus necesidades ideales, garantizando un desarrollo óptimo.';
    } else if (score >= 75) {
      return 'El $nombreCultivo es una excelente alternativa (Afinidad: ${score.toStringAsFixed(1)}%). Sus niveles de adaptabilidad encajan naturalmente con tu tierra.';
    } else {
      return 'El $nombreCultivo es viable (Afinidad: ${score.toStringAsFixed(1)}%). La tierra cumple con lo básico, aunque algunos parámetros están cerca de sus límites.';
    }
  }

  static List<Map<String, dynamic>> recomendarAlternativas({
    required double ph,
    required double ce,
    required double temp,
    required double humedad,
    required int idCultivoDescartado,
  }) {
    List<Map<String, dynamic>> catalogo = obtenerCatalogoCultivos();
    List<Map<String, dynamic>> recomendados = [];

    for (var cultivo in catalogo) {
      if (cultivo['id_cultivo'] == idCultivoDescartado) continue;

      ResultadoDiagnostico resultado = evaluarSuelo(
        idCultivo: cultivo['id_cultivo'],
        temp: temp,
        humedad: humedad,
        ph: ph,
        ce: ce,
      );

      if (resultado.esApto) {
        // Le pasamos el mapa completo a _calcularAfinidad
        double afinidad = _calcularAfinidad(cultivo, temp, humedad, ph, ce);
        String justificacion = _generarMotivo(cultivo['nombre'], afinidad);

        Map<String, dynamic> cultivoEnriquecido = Map<String, dynamic>.from(
          cultivo,
        );
        cultivoEnriquecido['afinidad'] = afinidad;
        cultivoEnriquecido['justificacion'] = justificacion;

        recomendados.add(cultivoEnriquecido);
      }
    }

    recomendados.sort((a, b) => b['afinidad'].compareTo(a['afinidad']));
    return recomendados;
  }
}
