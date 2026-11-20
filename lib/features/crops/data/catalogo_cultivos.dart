// lib/features/crops/data/catalogo_cultivos.dart
//
// Catálogo local de cultivos con los rangos por etapa, tomados del PDF de
// investigación del equipo. Las líneas marcadas con "REVISAR" son datos que
// el PDF no da completos o que se contradicen; confírmalos con tu equipo.

import '../domain/cultivo.dart';
import '../domain/etapa_cultivo.dart';
import '../domain/rango.dart';

class CatalogoCultivos {
  CatalogoCultivos._();

  /// Ids numéricos del catálogo viejo (ServicioDiagnostico) -> Cultivo.id
  static const Map<int, String> _claveDeIdNumerico = {
    1: 'tomate',
    2: 'frijol',
    3: 'cilantro',
    4: 'rabano',
  };

  static const List<Cultivo> todos = [_tomate, _frijol, _cilantro, _rabano];

  static Cultivo? porIdNumerico(int id) {
    final String? clave = _claveDeIdNumerico[id];
    if (clave == null) return null;
    for (final c in todos) {
      if (c.id == clave) return c;
    }
    return null;
  }

  /// Índice de la etapa en la que va una siembra, según los días que han
  /// pasado desde que se inició (0 = primera etapa, "Siembra").
  static int indiceEtapaActual(Cultivo cultivo, DateTime fechaInicio) {
    final int dias = DateTime.now().difference(fechaInicio).inDays;
    int acumulado = 0;
    for (int i = 0; i < cultivo.etapas.length; i++) {
      acumulado += cultivo.etapas[i].duracionEstimadaDias;
      if (dias < acumulado) return i;
    }
    return cultivo.etapas.length - 1;
  }

  // ---------------------------------------------------------------------
  // TOMATE
  // ---------------------------------------------------------------------
  static const Cultivo _tomate = Cultivo(
    id: 'tomate',
    nombre: 'Tomate rojo',
    carpetaImagenes: 'tomato',
    ph: Rango(6.0, 6.8), // suelo (5.5 a 6.5 en hidroponía)
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Se coloca la semilla en el suelo',
        temperatura: Rango(11, 34, optMin: 16, optMax: 29),
        humedad: Rango(65, 85, optMin: 70, optMax: 80),
        ce: Rango(1.0, 1.5),
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación',
        descripcion: 'La semilla brota y emerge del suelo',
        temperatura: Rango(11, 34, optMin: 16, optMax: 29),
        humedad: Rango(65, 85, optMin: 70, optMax: 80),
        ce: Rango(1.0, 1.5),
        duracionMinDias: 6,
        duracionMaxDias: 10,
      ),
      EtapaCultivo(
        clave: 'crecimiento',
        nombre: 'Crecimiento vegetativo',
        descripcion: 'La planta desarrolla tallo y hojas',
        temperatura: Rango(18, 32, optMin: 21, optMax: 24),
        humedad: Rango(60, 75, optMin: 65, optMax: 75),
        ce: Rango(2.0, 2.5),
        duracionMinDias: 25,
        duracionMaxDias: 35,
        notaTermica: 'En Yucatán el calor acelera el crecimiento vegetativo.',
      ),
      EtapaCultivo(
        clave: 'amarre',
        nombre: 'Amarre del fruto',
        descripcion: 'Aparecen las flores y se forman los frutos',
        temperatura: Rango(10, 30, optMin: 13, optMax: 24),
        humedad: Rango(70, 85, optMin: 75, optMax: 82),
        ce: Rango(2.5, 3.5),
        duracionMinDias: 25,
        duracionMaxDias: 40,
        notaTermica:
            'Con más de 30 °C de día o 20 °C de noche hay aborto de flores Y Falla en el amarre.',
      ),
      EtapaCultivo(
        clave: 'maduracion',
        nombre: 'Maduración',
        descripcion: 'El fruto madura y está listo para cosecha',
        temperatura: Rango(10, 30, optMin: 21, optMax: 24),
        humedad: Rango(50, 65, optMin: 55, optMax: 60),
        ce: Rango(2.5, 3.0),
        duracionMinDias: 10,
        duracionMaxDias: 15,
      ),
    ],
  );

  // ---------------------------------------------------------------------
  // FRIJOL
  // ---------------------------------------------------------------------
  static const Cultivo _frijol = Cultivo(
    id: 'frijol',
    nombre: 'Frijol',
    carpetaImagenes: 'bean',
    ph: Rango(6.0, 6.8),
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Se coloca la semilla en el suelo',
        temperatura: Rango(10, 25, optMin: 18, optMax: 24),
        humedad: Rango(55, 75, optMin: 60, optMax: 70),
        ce: Rango(0.8, 1.0),
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación y emergencia',
        descripcion: 'La semilla brota y emerge del suelo',
        temperatura: Rango(10, 25, optMin: 18, optMax: 24),
        humedad: Rango(55, 75, optMin: 60, optMax: 70),
        ce: Rango(0.8, 1.0),
        duracionMinDias: 20,
        duracionMaxDias: 25,
      ),
      EtapaCultivo(
        clave: 'crecimiento',
        nombre: 'Crecimiento vegetativo',
        descripcion: 'La planta desarrolla tallo y hojas',
        temperatura: Rango(10, 32, optMin: 20, optMax: 28),
        humedad: Rango(50, 70, optMin: 60, optMax: 65),
        ce: Rango(1.0, 1.2),
        duracionMinDias: 25,
        duracionMaxDias: 30,
      ),
      EtapaCultivo(
        clave: 'floracion',
        nombre: 'Floración y desarrollo del fruto',
        descripcion: 'Aparecen las flores y se forman las vainas',
        temperatura: Rango(10, 32, optMin: 20, optMax: 26),
        humedad: Rango(65, 85, optMin: 70, optMax: 80),
        ce: Rango(
          1.2,
          1.5,
        ), // Valores superiores a 2.0 dS/m provocan aborto floral
        duracionMinDias: 30,
        duracionMaxDias: 40,
        notaTermica: 'Arriba de 32 °C hay aborto de vainas y estrés térmico.',
      ),
      EtapaCultivo(
        clave: 'madurez',
        nombre: 'Madurez',
        descripcion: 'Las vainas maduran y se secan',
        temperatura: Rango(10, 32, optMin: 20, optMax: 30),
        humedad: Rango(40, 60, optMin: 45, optMax: 55),
        ce: Rango(1.0, 1.2),
        duracionMinDias: 15,
        duracionMaxDias: 20,
      ),
    ],
  );

  // ---------------------------------------------------------------------
  // CILANTRO
  // ---------------------------------------------------------------------
  static const Cultivo _cilantro = Cultivo(
    id: 'cilantro',
    nombre: 'Cilantro',
    carpetaImagenes: 'cilantro',
    ph: Rango(5.5, 6.8, optMin: 5.8, optMax: 6.5),
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Se coloca la semilla en el suelo',
        temperatura: Rango(10, 25, optMin: 12, optMax: 18),
        humedad: Rango(70, 90, optMin: 75, optMax: 85),
        ce: Rango(0.8, 1.2),
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación',
        descripcion: 'La semilla brota en el suelo',
        temperatura: Rango(10, 25, optMin: 12, optMax: 18),
        humedad: Rango(70, 90, optMin: 75, optMax: 85),
        ce: Rango(0.8, 1.2),
        duracionMinDias: 4,
        duracionMaxDias: 8,
      ),
      EtapaCultivo(
        clave: 'desarrollo',
        nombre: 'Desarrollo vegetativo',
        descripcion: 'La planta forma sus hojas',
        temperatura: Rango(15, 28, optMin: 18, optMax: 20),
        humedad: Rango(60, 75, optMin: 65, optMax: 70),
        ce: Rango(1.5, 2.5),
        duracionMinDias: 25,
        duracionMaxDias: 45,
        notaTermica: 'El calor de Yucatán provoca espigamiento anticipado.',
      ),
      EtapaCultivo(
        clave: 'maduracion',
        nombre: 'Maduración de semillas',
        descripcion: 'Las semillas maduran',
        temperatura: Rango(20, 32, optMin: 25, optMax: 30),
        humedad: Rango(45, 60, optMin: 50, optMax: 55),
        ce: Rango(2.0, 2.8),
        duracionMinDias: 20,
        duracionMaxDias: 30,
      ),
    ],
  );

  // ---------------------------------------------------------------------
  // RÁBANO
  // ---------------------------------------------------------------------
  static const Cultivo _rabano = Cultivo(
    id: 'rabano',
    nombre: 'Rábano',
    carpetaImagenes: 'radish', // REVISAR
    ph: Rango(5.5, 6.8, optMin: 6.0, optMax: 6.5),
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Se coloca la semilla en el suelo',
        temperatura: Rango(10, 25, optMin: 15, optMax: 22),
        humedad: Rango(70, 90, optMin: 75, optMax: 85),
        ce: Rango(0.8, 1.2),
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación y emergencia',
        descripcion: 'La semilla brota y emerge del suelo',
        temperatura: Rango(10, 25, optMin: 15, optMax: 22),
        humedad: Rango(70, 90, optMin: 75, optMax: 85),
        ce: Rango(0.8, 1.2),
        duracionMinDias: 5,
        duracionMaxDias: 7,
      ),
      EtapaCultivo(
        clave: 'crecimiento',
        nombre: 'Crecimiento vegetativo',
        descripcion: 'La planta desarrolla sus hojas',
        temperatura: Rango(10, 25, optMin: 15, optMax: 20),
        humedad: Rango(65, 80, optMin: 70, optMax: 75),
        ce: Rango(1.2, 1.5),
        duracionMinDias: 7,
        duracionMaxDias: 10,
      ),
      EtapaCultivo(
        clave: 'engrosamiento',
        nombre: 'Engrosamiento de la raíz',
        descripcion: 'La raíz crece y se engrosa',
        temperatura: Rango(10, 30, optMin: 15, optMax: 22),
        humedad: Rango(70, 85, optMin: 75, optMax: 80),
        ce: Rango(1.8, 2.0),
        duracionMinDias: 10,
        duracionMaxDias: 12,
        notaTermica:
            'Temperaturas superiores de 25 a 30 °C aumentan el estrés y hacen que la raíz sea leñosa o picante.',
      ),
      EtapaCultivo(
        clave: 'madurez',
        nombre: 'Madurez',
        descripcion: 'La raíz está lista para cosecha',
        temperatura: Rango(10, 30, optMin: 15, optMax: 22),
        humedad: Rango(55, 70, optMin: 60, optMax: 65),
        ce: Rango(1.5, 1.8),
        duracionMinDias: 3,
        duracionMaxDias: 5,
        notaTermica: 'Evita la senescencia o el ahuecado de la raíz.',
      ),
    ],
  );
}
