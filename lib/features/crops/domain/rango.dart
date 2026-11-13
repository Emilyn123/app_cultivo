/// Resultado de comparar un valor medido contra un [Rango].
enum EstadoParametro { optimo, aceptable, fueraDeRango }

/// Rango permitido de un parámetro (pH, CE, temperatura o humedad).
///
/// - [min] y [max]: límites absolutos. Fuera de ellos el valor es perjudicial.
/// - [optMin] y [optMax]: rango ideal (opcional). Si el valor está entre
///   [min] y [max] pero fuera del óptimo, se considera "aceptable".
class Rango {
  final double min;
  final double max;
  final double? optMin;
  final double? optMax;

  const Rango(this.min, this.max, {this.optMin, this.optMax});

  EstadoParametro evaluar(double valor) {
    if (valor < min || valor > max) return EstadoParametro.fueraDeRango;

    final double? oMin = optMin;
    final double? oMax = optMax;
    if (oMin != null && oMax != null && (valor < oMin || valor > oMax)) {
      return EstadoParametro.aceptable;
    }
    return EstadoParametro.optimo;
  }

  /// Texto del rango óptimo, por ejemplo "6.0 - 6.8".
  /// Si no hay óptimo definido, usa el rango completo.
  String textoOptimo({int decimales = 1}) {
    final double desde = optMin ?? min;
    final double hasta = optMax ?? max;
    return '${desde.toStringAsFixed(decimales)} - ${hasta.toStringAsFixed(decimales)}';
  }
}
