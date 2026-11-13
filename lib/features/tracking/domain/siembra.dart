import '../../crops/domain/cultivo.dart';
import '../../crops/domain/etapa_cultivo.dart';

/// Un cultivo que el usuario está sembrando: qué cultivo es y desde cuándo.
/// La etapa actual NO se guarda: se calcula con la fecha de siembra.
class Siembra {
  final String id;

  /// Nombre que le pone el usuario ("Cultivo 1", "Parcela norte"...).
  final String nombre;

  /// Opcional: "rojo" en "Cultivo de tomate rojo".
  final String? variedad;

  final Cultivo cultivo;
  final DateTime fechaSiembra;

  Siembra({
    required this.id,
    required this.nombre,
    required this.cultivo,
    required this.fechaSiembra,
    this.variedad,
  });

  /// Texto como "Cultivo de tomate rojo".
  String get descripcion {
    final String extra = variedad == null ? '' : ' $variedad';
    return 'Cultivo de ${cultivo.nombre.toLowerCase()}$extra';
  }

  /// Posición (0, 1, 2...) de la etapa en la que va la siembra hoy.
  /// Suma las duraciones estimadas de las etapas hasta superar los días
  /// transcurridos. Si ya pasó todo el ciclo, devuelve la última etapa.
  int indiceEtapaActual({DateTime? hoy}) {
    final int dias =
        _soloFecha(hoy ?? DateTime.now()).difference(_soloFecha(fechaSiembra)).inDays;

    int acumulado = 0;
    for (int i = 0; i < cultivo.etapas.length; i++) {
      acumulado += cultivo.etapas[i].duracionEstimadaDias;
      if (dias < acumulado) return i;
    }
    return cultivo.etapas.length - 1;
  }

  EtapaCultivo etapaActual({DateTime? hoy}) =>
      cultivo.etapas[indiceEtapaActual(hoy: hoy)];

  // Se usa UTC para que el horario de verano no altere el conteo de días.
  static DateTime _soloFecha(DateTime d) => DateTime.utc(d.year, d.month, d.day);
}
