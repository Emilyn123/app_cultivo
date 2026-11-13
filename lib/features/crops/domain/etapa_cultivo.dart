import 'rango.dart';

/// Una etapa de crecimiento de un cultivo, con los rangos que aplican a ella.
class EtapaCultivo {
  /// Identificador sin acentos ni espacios ('siembra', 'germinacion',
  /// 'crecimiento', 'amarre', 'maduracion'). Se usa para armar las rutas
  /// de las imágenes y, más adelante, es la columna `clave` en Supabase.
  final String clave;

  /// Nombre para mostrar, por ejemplo "Crecimiento vegetativo".
  final String nombre;

  /// Frase corta que aparece en el panel general de etapas.
  final String descripcion;

  /// Dato extra opcional del panel, por ejemplo "Profundidad: 1 cm | Riego: ligero".
  final String detalle;

  final int? duracionMinDias;
  final int? duracionMaxDias;

  final Rango temperatura; // °C
  final Rango humedad; // %
  final Rango ce; // dS/m (equivale a mS/cm)

  final String? notaNutricion;
  final String? notaTermica;

  const EtapaCultivo({
    required this.clave,
    required this.nombre,
    required this.descripcion,
    required this.temperatura,
    required this.humedad,
    required this.ce,
    this.detalle = '',
    this.duracionMinDias,
    this.duracionMaxDias,
    this.notaNutricion,
    this.notaTermica,
  });

  /// Duración que se usa para calcular en qué etapa va una siembra:
  /// el promedio entre el mínimo y el máximo. Si la etapa no tiene duración
  /// (como "Siembra", que es un solo día), cuenta como 1 día.
  int get duracionEstimadaDias {
    final int? min = duracionMinDias;
    final int? max = duracionMaxDias;
    if (min != null && max != null) return ((min + max) / 2).round();
    return 1;
  }
}
