/// Arma las rutas de las imágenes a partir de la carpeta del cultivo
/// (por ejemplo 'tomato') y la clave de la etapa (por ejemplo 'germinacion').
///
/// Así ninguna pantalla escribe rutas a mano: para agregar un cultivo nuevo
/// basta con crear su carpeta y nombrar los archivos con la misma convención.
class RutasImagenes {
  RutasImagenes._();

  static const String _base = 'assets/images';

  /// Imágenes compartidas por todos los cultivos.
  static const String tierra = '$_base/common/tierra.png';
  static const String fondoCampo = '$_base/common/fondo_campo.png';
  static const String encabezadoSeguimiento =
      '$_base/common/encabezado_seguimiento.png';

  static String letrero(String carpeta, String clave) =>
      '$_base/crops/$carpeta/signs/letrero_$clave.png';

  static String fondo(String carpeta, String clave) =>
      '$_base/crops/$carpeta/backgrounds/fondo_$clave.jpg';

  static String icono(String carpeta, String clave) =>
      '$_base/crops/$carpeta/icons/icono_$clave.png';

  /// Icono que representa al cultivo completo (tarjetas de "Mis cultivos").
  static String iconoCultivo(String carpeta) =>
      '$_base/crops/$carpeta/icons/icono_cultivo.png';

  static String ilustracion(String carpeta, String clave) =>
      '$_base/crops/$carpeta/illustrations/ilustracion_$clave.png';
}
