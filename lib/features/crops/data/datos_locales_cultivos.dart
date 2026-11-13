import '../domain/cultivo.dart';
import '../domain/etapa_cultivo.dart';
import '../domain/rango.dart';

/// DATOS TEMPORALES escritos en código.
/// Cuando conectes Supabase, este archivo se borra y
/// `repositorio_cultivos.dart` lee los mismos datos de la base.
///
/// Cómo leer un rango:  Rango(min, max, optMin: x, optMax: y)
///   - min / max        → límites; fuera de ellos el valor es perjudicial.
///   - optMin / optMax  → rango ideal.
///
/// Las claves de las etapas ('siembra', 'germinacion', ...) deben coincidir
/// con los nombres de los archivos de imagen (fondo_siembra.jpg, etc.).
/// La etapa 'siembra' no tiene duración: es un solo día y usa los mismos
/// rangos que la germinación.
class DatosLocalesCultivos {
  DatosLocalesCultivos._();

  // ======================================================================
  // TOMATE  (carpeta de imágenes: tomato)
  // ======================================================================
  static const String _notaNocheTomate =
      'Noche: mín 10, máx 20, óptima 13-18 °C. '
      'Día >30 °C o noche >20 °C provoca aborto floral.';

  static const Cultivo tomate = Cultivo(
    id: 'tomate',
    nombre: 'Tomate',
    carpetaImagenes: 'tomato',
    ph: Rango(5.5, 6.8, optMin: 6.0, optMax: 6.8),
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Comienza con semillas de calidad en tierra fértil',
        detalle: 'Profundidad: 1 cm | Riego: ligero',
        temperatura: Rango(11, 34, optMin: 16, optMax: 29),
        humedad: Rango(65, 85, optMin: 70, optMax: 80),
        ce: Rango(1.0, 1.8, optMin: 1.0, optMax: 1.5),
        notaNutricion: 'Solución ligera.',
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación',
        descripcion: 'Cotiledones aparecen y se generan las primeras raíces',
        duracionMinDias: 6,
        duracionMaxDias: 10,
        temperatura: Rango(11, 34, optMin: 16, optMax: 29),
        humedad: Rango(65, 85, optMin: 70, optMax: 80),
        ce: Rango(1.0, 1.8, optMin: 1.0, optMax: 1.5),
        notaNutricion: 'Solución ligera.',
      ),
      EtapaCultivo(
        clave: 'crecimiento',
        nombre: 'Crecimiento vegetativo',
        descripcion: 'Crecimiento vigoroso de las primeras hojas verdaderas',
        detalle: 'Luz de sol: Alta | Humedad: Moderada',
        duracionMinDias: 25,
        duracionMaxDias: 35,
        temperatura: Rango(18, 32, optMin: 21, optMax: 24),
        humedad: Rango(60, 75, optMin: 65, optMax: 75),
        ce: Rango(1.7, 2.8, optMin: 2.0, optMax: 2.5),
        notaNutricion: 'Biomasa foliar.',
      ),
      // Amarre: une Floración y cuajado (CE 2.5-3.0) con Llenado de fruto (3.0-3.5).
      EtapaCultivo(
        clave: 'amarre',
        nombre: 'Amarre del fruto',
        descripcion: 'Aparición de flores y los primeros frutos',
        duracionMinDias: 25,
        duracionMaxDias: 40,
        temperatura: Rango(18, 30, optMin: 19, optMax: 24),
        humedad: Rango(70, 85, optMin: 75, optMax: 82),
        ce: Rango(2.2, 3.5, optMin: 2.5, optMax: 3.5),
        notaNutricion:
            'Sostenimiento floral. Una CE alta en el llenado aumenta °Brix, acidez y firmeza.',
        notaTermica: _notaNocheTomate,
      ),
      EtapaCultivo(
        clave: 'maduracion',
        nombre: 'Maduración',
        descripcion: '¡Tomates listos! Cosecha cuando se encuentren rojos.',
        duracionMinDias: 10,
        duracionMaxDias: 15,
        temperatura: Rango(10, 30, optMin: 21, optMax: 24),
        humedad: Rango(50, 65, optMin: 55, optMax: 60),
        ce: Rango(2.2, 3.3, optMin: 2.5, optMax: 3.0),
        notaNutricion: 'Cosecha final.',
      ),
    ],
  );

  // ======================================================================
  // FRIJOL  (carpeta de imágenes: bean)
  // ======================================================================
  static const Cultivo frijol = Cultivo(
    id: 'frijol',
    nombre: 'Frijol',
    carpetaImagenes: 'bean',
    // Muy sensible a pH menor de 5.5 y mayor de 7.5.
    ph: Rango(5.5, 7.5, optMin: 6.0, optMax: 6.8),
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Siembra semillas sanas en suelo suelto y bien drenado',
        detalle: 'Profundidad: 3-5 cm | Riego: ligero',
        temperatura: Rango(12, 32, optMin: 18, optMax: 24),
        humedad: Rango(55, 75, optMin: 60, optMax: 70),
        ce: Rango(0.8, 1.3, optMin: 0.8, optMax: 1.0),
        notaNutricion: 'Agua de muy baja salinidad.',
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación',
        descripcion: 'La semilla se hincha y emerge la raíz con los cotiledones',
        duracionMinDias: 20,
        duracionMaxDias: 25,
        temperatura: Rango(12, 32, optMin: 18, optMax: 24),
        humedad: Rango(55, 75, optMin: 60, optMax: 70),
        ce: Rango(0.8, 1.3, optMin: 0.8, optMax: 1.0),
        notaNutricion: 'Agua de muy baja salinidad.',
      ),
      EtapaCultivo(
        clave: 'crecimiento',
        nombre: 'Crecimiento vegetativo',
        descripcion: 'Se desarrollan las hojas y la planta gana fuerza',
        duracionMinDias: 25,
        duracionMaxDias: 30,
        temperatura: Rango(15, 32, optMin: 20, optMax: 30),
        humedad: Rango(50, 70, optMin: 60, optMax: 65),
        ce: Rango(0.8, 1.5, optMin: 1.0, optMax: 1.2),
        notaNutricion: 'Desarrollo foliar.',
      ),
      // Floración y desarrollo de fruto (vaina).
      EtapaCultivo(
        clave: 'amarre',
        nombre: 'Amarre del fruto',
        descripcion: 'Aparecen las flores y se forman las primeras vainas',
        detalle: 'Evita temperaturas mayores a 32 °C',
        duracionMinDias: 30,
        duracionMaxDias: 40,
        temperatura: Rango(15, 32, optMin: 20, optMax: 26),
        humedad: Rango(65, 85, optMin: 70, optMax: 80),
        ce: Rango(0.9, 1.8, optMin: 1.2, optMax: 1.5),
        notaNutricion: 'CE >2.0 dS/m provoca aborto floral.',
        notaTermica: 'T° >32 °C aborta vainas.',
      ),
      EtapaCultivo(
        clave: 'maduracion',
        nombre: 'Maduración',
        descripcion: 'Las vainas terminan de madurar y están listas para cosechar',
        duracionMinDias: 15,
        duracionMaxDias: 20,
        temperatura: Rango(15, 32, optMin: 20, optMax: 28),
        humedad: Rango(40, 60, optMin: 45, optMax: 55),
        ce: Rango(0.8, 1.5, optMin: 1.0, optMax: 1.2),
        notaNutricion: 'Maduración de vainas.',
        notaTermica: 'T° >32 °C causa aborto.',
      ),
    ],
  );

  // ======================================================================
  // CILANTRO  (carpeta de imágenes: cilantro) — 4 etapas
  //   germinacion = Germinación + Emergencia y establecimiento
  //   maduracion  = Floración + Maduración de semillas
  // En las etapas unidas: el rango aceptable abarca ambas etapas y el
  // óptimo cubre los dos óptimos.
  // ======================================================================
  static const Cultivo cilantro = Cultivo(
    id: 'cilantro',
    nombre: 'Cilantro',
    carpetaImagenes: 'cilantro',
    ph: Rango(5.5, 6.8, optMin: 5.8, optMax: 6.5),
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Siembra las semillas en tierra suelta y bien drenada',
        detalle: 'Profundidad: 1-2 cm | Riego: ligero',
        temperatura: Rango(13, 24, optMin: 18, optMax: 20),
        humedad: Rango(70, 90, optMin: 75, optMax: 85),
        ce: Rango(0.8, 1.5, optMin: 0.8, optMax: 1.2),
        notaNutricion: 'Evita estrés osmótico.',
        notaTermica: 'Suelo <23.8 °C.',
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación',
        descripcion: 'Brota la raíz, aparecen las primeras hojitas y la plántula se establece',
        detalle: 'Temperatura ideal: 18-20 °C',
        duracionMinDias: 24,
        duracionMaxDias: 33,
        temperatura: Rango(13, 24, optMin: 18, optMax: 20),
        humedad: Rango(65, 90, optMin: 70, optMax: 85),
        ce: Rango(0.8, 1.8, optMin: 0.8, optMax: 1.5),
        notaNutricion: 'Evita estrés osmótico. Establecimiento inicial.',
        notaTermica: 'Mínima funcional 13 °C. Suelo <23.8 °C.',
      ),
      EtapaCultivo(
        clave: 'crecimiento',
        nombre: 'Crecimiento vegetativo',
        descripcion: 'Las hojas crecen y se desarrolla el follaje aromático',
        detalle: 'Evita temperaturas mayores a 24 °C',
        duracionMinDias: 25,
        duracionMaxDias: 45,
        temperatura: Rango(13, 24, optMin: 18, optMax: 20),
        humedad: Rango(60, 75, optMin: 65, optMax: 70),
        ce: Rango(1.2, 2.8, optMin: 1.5, optMax: 2.5),
        notaNutricion: 'Biomasa foliar y aceites esenciales.',
        notaTermica: 'Evitar T° mayores a 24 °C.',
      ),
      EtapaCultivo(
        clave: 'maduracion',
        nombre: 'Floración y semillas',
        descripcion: 'La planta florece y produce semillas (culantro)',
        detalle: 'El calor sobre 25-28 °C acelera el espigamiento',
        duracionMinDias: 34,
        duracionMaxDias: 51,
        temperatura: Rango(18, 35, optMin: 25, optMax: 32),
        humedad: Rango(45, 70, optMin: 50, optMax: 65),
        ce: Rango(1.7, 2.8, optMin: 2.0, optMax: 2.8),
        notaNutricion: 'Fase reproductiva/semilla.',
        notaTermica: 'T° >25-28 °C acelera el espigamiento.',
      ),
    ],
  );

  // ======================================================================
  // RÁBANO  (carpeta de imágenes: radish)
  // ======================================================================
  static const Cultivo rabano = Cultivo(
    id: 'rabano',
    nombre: 'Rábano',
    carpetaImagenes: 'radish',
    ph: Rango(5.5, 6.8, optMin: 6.0, optMax: 6.5),
    etapas: [
      EtapaCultivo(
        clave: 'siembra',
        nombre: 'Siembra',
        descripcion: 'Siembra directa de las semillas en suelo suelto',
        detalle: 'Profundidad: 1 cm | Riego: ligero',
        temperatura: Rango(10, 30, optMin: 15, optMax: 22),
        humedad: Rango(70, 90, optMin: 75, optMax: 85),
        ce: Rango(0.8, 1.5, optMin: 0.8, optMax: 1.2),
        notaNutricion: 'Etapa inicial (días 1-7).',
      ),
      EtapaCultivo(
        clave: 'germinacion',
        nombre: 'Germinación',
        descripcion: 'La semilla brota y aparecen las primeras hojas',
        duracionMinDias: 5,
        duracionMaxDias: 7,
        temperatura: Rango(10, 30, optMin: 15, optMax: 22),
        humedad: Rango(70, 90, optMin: 75, optMax: 85),
        ce: Rango(0.8, 1.5, optMin: 0.8, optMax: 1.2),
        notaNutricion: 'Etapa inicial (días 1-7).',
      ),
      EtapaCultivo(
        clave: 'crecimiento',
        nombre: 'Crecimiento vegetativo',
        descripcion: 'Las hojas se expanden y la planta se fortalece',
        duracionMinDias: 7,
        duracionMaxDias: 10,
        temperatura: Rango(10, 30, optMin: 15, optMax: 20),
        humedad: Rango(65, 80, optMin: 70, optMax: 75),
        ce: Rango(0.9, 1.8, optMin: 1.2, optMax: 1.5),
        notaNutricion: 'Expansión foliar (días 8-17).',
      ),
      EtapaCultivo(
        clave: 'amarre',
        nombre: 'Engrosamiento de la raíz',
        descripcion: 'La raíz se engrosa y toma su forma y color',
        detalle: 'Evita el estrés hídrico y el calor (25-30 °C)',
        duracionMinDias: 10,
        duracionMaxDias: 12,
        temperatura: Rango(10, 30, optMin: 15, optMax: 20),
        humedad: Rango(70, 85, optMin: 75, optMax: 80),
        ce: Rango(1.5, 2.3, optMin: 1.8, optMax: 2.0),
        notaNutricion: 'Carga K y Ca. CE >2.5 la vuelve picante (días 18-27).',
        notaTermica: 'T° de 25-30 °C o estrés hídrico: raíz leñosa, picante o hueca.',
      ),
      EtapaCultivo(
        clave: 'maduracion',
        nombre: 'Madurez comercial',
        descripcion: '¡Rábanos listos! Cosecha antes de que se pongan leñosos',
        duracionMinDias: 3,
        duracionMaxDias: 5,
        temperatura: Rango(10, 30, optMin: 15, optMax: 22),
        humedad: Rango(55, 70, optMin: 60, optMax: 65),
        ce: Rango(1.2, 2.1, optMin: 1.5, optMax: 1.8),
        notaNutricion: 'Cosecha final (días 28-30).',
        notaTermica: 'Prevenir senescencia.',
      ),
    ],
  );

  // ======================================================================
  // CATÁLOGO (el orden de esta lista es el de la pantalla de selección)
  // ======================================================================
  static const List<Cultivo> cultivos = [tomate, frijol, cilantro, rabano];

  static Cultivo porId(String id) =>
      cultivos.firstWhere((c) => c.id == id);
}
