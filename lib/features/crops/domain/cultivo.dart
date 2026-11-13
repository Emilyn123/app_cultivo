import 'etapa_cultivo.dart';
import 'rango.dart';

class Cultivo {
  /// Identificador del cultivo ('tomate', 'frijol', 'cilantro', 'rabano').
  final String id;
  final String nombre;

  /// Carpeta de imágenes dentro de assets/images/crops/ ('tomato', 'bean'...).
  final String carpetaImagenes;

  /// El pH es el mismo durante todo el ciclo del cultivo.
  final Rango ph;

  final List<EtapaCultivo> etapas;

  const Cultivo({
    required this.id,
    required this.nombre,
    required this.carpetaImagenes,
    required this.ph,
    required this.etapas,
  });

  /// Líneas de texto para la tarjeta "REQUERIMIENTOS NECESARIOS" de una etapa.
  List<String> requerimientosEtapa(EtapaCultivo etapa) => [
        'PH: ${ph.textoOptimo()}',
        'CE: ${etapa.ce.textoOptimo()} mS/cm',
        'TEMP: ${etapa.temperatura.textoOptimo(decimales: 0)} °C',
        'HUMEDAD: ${etapa.humedad.textoOptimo(decimales: 0)}%',
      ];
}
