// lib/features/monitor/domain/servicio_diagnostico.dart

class ResultadoDiagnostico {
  final bool esApto;
  final List<String> mensajesAlerta;

  // Banderas individuales para saber qué cubo pintar de rojo en el Paso 6
  final bool phOk;
  final bool ceOk;
  final bool tempOk;
  final bool humedadOk;

  ResultadoDiagnostico({
    required this.esApto,
    required this.mensajesAlerta,
    required this.phOk,
    required this.ceOk,
    required this.tempOk,
    required this.humedadOk,
  });
}

class ServicioDiagnostico {
  /// Catálogo centralizado con los parámetros óptimos
  static List<Map<String, dynamic>> obtenerCatalogoCultivos() {
    return [
      {
        'id_cultivo': 1,
        'nombre': 'TOMATE ROJO',
        'imagenPath':
            'assets/images/tomate_rojo.png', // Usado en las tarjetas[cite: 1, 9]
        'ph': '6.0 - 6.8',
        'ce': '1.0 a 1.5 dS/m',
        'temp': '11.0 a 34.0°C', // Rango térmico[cite: 3]
        'hum': '65% - 85%',
      },
      {
        'id_cultivo': 2,
        'nombre': 'FRIJOL',
        'imagenPath': 'assets/images/frijol.png',
        'ph': '6.0 - 6.8',
        'ce': '0.8 a 1.0 dS/m', // Sensible a salinidad[cite: 3]
        'temp': '10.0 a 15.0°C',
        'hum': '55% - 75%',
      },
      {
        'id_cultivo': 3,
        'nombre': 'CILANTRO',
        'imagenPath': 'assets/images/cilantro.png',
        'ph': '5.5 - 6.8',
        'ce': '0.8 a 1.2 dS/m',
        'temp': '18.0 a 25.0°C',
        'hum': '70% - 90%',
      },
      {
        'id_cultivo': 4,
        'nombre': 'RABANO',
        'imagenPath': 'assets/images/rabano.png',
        'ph': '5.5 - 6.8',
        'ce': '0.8 a 1.2 dS/m',
        'temp': '15.0 a 22.0°C',
        'hum': '70% - 90%',
      },
    ];
  }

  /// Evalúa las lecturas del suelo contra los parámetros óptimos del cultivo
  static ResultadoDiagnostico evaluarSuelo({
    required int idCultivo,
    required double temp,
    required double humedad,
    required double ph,
    required double ce,
  }) {
    // Definimos variables temporales para los rangos en el nuevo orden
    double minTemp = 0, maxTemp = 0;
    double minHum = 0, maxHum = 0;
    double minPh = 0, maxPh = 0;
    double minCe = 0, maxCe = 0;

    // Catálogo Offline-First basado en la investigación de tu equipo para Yucatán
    switch (idCultivo) {
      case 1: // Tomate Rojo
        minTemp = 11.0;
        maxTemp = 34.0; // Tolerancia al calor de Yucatán
        minHum = 65.0;
        maxHum = 85.0;
        minPh = 6.0;
        maxPh = 6.8;
        minCe = 1.0;
        maxCe = 1.5;
        break;
      case 2: // Frijol
        minTemp = 10.0;
        maxTemp = 15.0;
        minHum = 55.0;
        maxHum = 75.0;
        minPh = 6.0;
        maxPh = 6.8;
        minCe = 0.8;
        maxCe = 1.0; // Muy sensible a la salinidad
        break;
      case 3: // Cilantro
        minTemp = 18.0;
        maxTemp = 25.0;
        minHum = 70.0;
        maxHum = 90.0;
        minPh = 5.5;
        maxPh = 6.8;
        minCe = 0.8;
        maxCe = 1.2;
        break;
      case 4: // Rábano
        minTemp = 15.0;
        maxTemp = 22.0;
        minHum = 70.0;
        maxHum = 90.0;
        minPh = 5.5;
        maxPh = 6.8;
        minCe = 0.8;
        maxCe = 1.2;
        break;
      default:
        // Rangos genéricos de seguridad si el ID no coincide
        minTemp = 20.0;
        maxTemp = 30.0;
        minHum = 50.0;
        maxHum = 80.0;
        minPh = 6.0;
        maxPh = 7.0;
        minCe = 1.0;
        maxCe = 2.0;
    }

    // Evaluamos cada parámetro matemáticamente en el nuevo orden
    bool tempOk = temp >= minTemp && temp <= maxTemp;
    bool humedadOk = humedad >= minHum && humedad <= maxHum;
    bool phOk = ph >= minPh && ph <= maxPh;
    bool ceOk = ce >= minCe && ce <= maxCe;

    List<String> alertas = [];

    // Generamos los diagnósticos específicos si algo falla en el nuevo orden
    if (!tempOk)
      alertas.add(temp > maxTemp ? 'Estrés por calor' : 'Temperatura baja');
    if (!humedadOk)
      alertas.add(humedad < minHum ? 'Suelo muy seco' : 'Exceso de humedad');
    if (!phOk)
      alertas.add(
        ph < minPh ? 'Suelo demasiado ácido' : 'Suelo demasiado alcalino',
      );
    if (!ceOk)
      alertas.add(ce > maxCe ? 'Alta salinidad' : 'Baja conductividad');

    // El suelo es apto únicamente si no se generó ninguna alerta
    bool esApto = alertas.isEmpty;

    return ResultadoDiagnostico(
      esApto: esApto,
      mensajesAlerta: alertas,
      phOk: phOk,
      ceOk: ceOk,
      tempOk: tempOk,
      humedadOk: humedadOk,
    );
  }

  /// Motor que filtra el catálogo y devuelve SOLO los cultivos aptos para la tierra actual
  static List<Map<String, dynamic>> recomendarAlternativas({
    required double ph,
    required double ce,
    required double temp,
    required double humedad,
    required int idCultivoDescartado,
  }) {
    // 1. Traemos todos los cultivos disponibles
    List<Map<String, dynamic>> catalogoCompleto = obtenerCatalogoCultivos();
    List<Map<String, dynamic>> recomendados = [];

    // 2. Evaluamos la tierra del usuario contra cada planta del catálogo
    for (var cultivo in catalogoCompleto) {
      if (cultivo['id_cultivo'] == idCultivoDescartado) continue;
      ResultadoDiagnostico resultado = evaluarSuelo(
        idCultivo: cultivo['id_cultivo'],
        ph: ph,
        ce: ce,
        temp: temp,
        humedad: humedad,
      );

      // 3. Si la tierra cumple con los requisitos, lo agregamos a las recomendaciones
      if (resultado.esApto) {
        recomendados.add(cultivo);
      }
    }

    return recomendados;
  }
}
