// lib/features/weather/domain/clima.dart

class ClimaActual {
  final double temperatura;
  final double humedadAire;
  final double viento;
  final double precipitacion;
  final String fuente; // "Open-Meteo"

  ClimaActual({
    required this.temperatura,
    required this.humedadAire,
    required this.viento,
    required this.precipitacion,
    this.fuente = 'Open-Meteo',
  });

  factory ClimaActual.fromJson(Map<String, dynamic> json) {
    // Open-Meteo devuelve los datos actuales en la clave 'current'
    final current = json['current'];
    return ClimaActual(
      temperatura: (current['temperature_2m'] as num).toDouble(),
      humedadAire: (current['relative_humidity_2m'] as num).toDouble(),
      viento: (current['wind_speed_10m'] as num).toDouble(),
      precipitacion: (current['precipitation'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PronosticoDia {
  final DateTime fecha;
  final double tempMax;
  final double tempMin;
  final double probabilidadLluvia;
  final double precipitacionTotal;

  PronosticoDia({
    required this.fecha,
    required this.tempMax,
    required this.tempMin,
    required this.probabilidadLluvia,
    required this.precipitacionTotal,
  });

  factory PronosticoDia.fromJson(Map<String, dynamic> daily, int index) {
    return PronosticoDia(
      fecha: DateTime.parse(daily['time'][index]),
      tempMax: (daily['temperature_2m_max'][index] as num).toDouble(),
      tempMin: (daily['temperature_2m_min'][index] as num).toDouble(),
      probabilidadLluvia:
          (daily['precipitation_probability_max'][index] as num?)?.toDouble() ??
          0.0,
      precipitacionTotal:
          (daily['precipitation_sum'][index] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ClimaCompleto {
  final ClimaActual actual;
  final List<PronosticoDia> pronostico;

  ClimaCompleto({required this.actual, required this.pronostico});

  factory ClimaCompleto.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'];
    List<PronosticoDia> listaPronosticos = [];

    // Open-Meteo devuelve 7 días por defecto, iteramos sobre ellos
    if (daily != null && daily['time'] != null) {
      for (int i = 0; i < (daily['time'] as List).length; i++) {
        listaPronosticos.add(PronosticoDia.fromJson(daily, i));
      }
    }

    return ClimaCompleto(
      actual: ClimaActual.fromJson(json),
      pronostico: listaPronosticos,
    );
  }
}
