import '../../crops/data/datos_locales_cultivos.dart';
import '../domain/siembra.dart';

/// DATOS TEMPORALES de prueba. Cuando conectes Supabase, este archivo se
/// reemplaza por `repositorio_siembras.dart`, que lee la tabla `siembras`
/// del usuario.
class DatosLocalesSiembras {
  DatosLocalesSiembras._();

  // Las fechas se calculan "hace N días" para que cada ejemplo muestre
  // siempre la misma etapa, sin importar qué día ejecutes la app.
  static DateTime _haceDias(int dias) =>
      DateTime.now().subtract(Duration(days: dias));

  static final List<Siembra> siembras = [
    Siembra(
      id: '1',
      nombre: 'Cultivo 1',
      variedad: 'rojo',
      cultivo: DatosLocalesCultivos.tomate,
      fechaSiembra: _haceDias(26), // → Crecimiento vegetativo
    ),
    Siembra(
      id: '2',
      nombre: 'Cultivo 2',
      cultivo: DatosLocalesCultivos.cilantro,
      fechaSiembra: _haceDias(40), // → Crecimiento vegetativo
    ),
    Siembra(
      id: '3',
      nombre: 'Cultivo 3',
      cultivo: DatosLocalesCultivos.frijol,
      fechaSiembra: _haceDias(60), // → Amarre del fruto
    ),
    Siembra(
      id: '4',
      nombre: 'Cultivo 4',
      cultivo: DatosLocalesCultivos.rabano,
      fechaSiembra: _haceDias(0), // → Siembra (sembrado hoy)
    ),
  ];
}
