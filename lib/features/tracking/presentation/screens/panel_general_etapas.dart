import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
// Importa la pantalla de detalle que creamos antes para poder navegar a ella
import 'detalle_etapas_cultivo.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../crops/domain/cultivo.dart';
import '../../../crops/domain/etapa_cultivo.dart';

class PanelGeneralEtapas extends StatelessWidget {
  final Cultivo cultivo;

  const PanelGeneralEtapas({super.key, required this.cultivo});

  @override
  Widget build(BuildContext context) {
    // Las etapas salen del cultivo: puede haber 4 o 5 según el cultivo.
    final List<EtapaCultivo> etapas = cultivo.etapas;

    final Size tamanoPantalla = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: tamanoPantalla.width,
        height: tamanoPantalla.height,
        child: Stack(
          fit: StackFit
              .expand, // Fuerza a los hijos a expandirse a toda la pantalla
          children: [
            // 1. Imagen de fondo
            Image.asset(
              RutasImagenes.fondoCampo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF131A15)),
            ),

            // 2. Capa oscura para contraste
            Container(color: Colors.black.withOpacity(0.25)),

            // 3. Contenido
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.04,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        EncabezadoPersonalizado(
                          titulo: 'Guía de seguimiento del cultivo',
                        ),
                        const SizedBox(height: 18.0),

                        ...List.generate(etapas.length, (index) {
                          final EtapaCultivo etapa = etapas[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleEtapaSeguimiento(
                                      cultivo: cultivo,
                                      etapaInicial:
                                          index, // 0 = primera etapa, 1 = segunda, etc.
                                    ),
                                  ),
                                );
                              },
                              child: _TarjetaEtapa(
                                titulo: '${index + 1}.${etapa.nombre}',
                                descripcion: etapa.descripcion,
                                detalle: etapa.detalle,
                                rutaImagen: RutasImagenes.icono(
                                  cultivo.carpetaImagenes,
                                  etapa.clave,
                                ),
                                anchoMaximo: constraints.maxWidth,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget modular para cada tarjeta de etapa
class _TarjetaEtapa extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String detalle;
  final String rutaImagen;
  final double anchoMaximo;

  const _TarjetaEtapa({
    required this.titulo,
    required this.descripcion,
    required this.detalle,
    required this.rutaImagen,
    required this.anchoMaximo,
  });

  @override
  Widget build(BuildContext context) {
    // Dimensiones proporcionales al ancho de pantalla
    final double tamanoIcono = (anchoMaximo * 0.18).clamp(60.0, 85.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: const Color(
          0xFF223521,
        ).withOpacity(0.92), // Tono verde oliva oscuro
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen ilustrativa de la etapa.
          // Si el cultivo aún no tiene su icono, muestra uno genérico.
          Image.asset(
            rutaImagen,
            width: tamanoIcono,
            height: tamanoIcono,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => SizedBox(
              width: tamanoIcono,
              height: tamanoIcono,
              child: Icon(
                Icons.eco_rounded,
                size: tamanoIcono * 0.6,
                color: Colors.white54,
              ),
            ),
          ),

          const SizedBox(width: 12.0),

          // Textos informativos de la etapa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1, // Fuerza a que el título entre en una sola línea
                  minFontSize:
                      14.0, // Si la pantalla es angosta, reducirá hasta 14px
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6.0),
                AutoSizeText(
                  descripcion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.25,
                  ),
                  maxLines: 3,
                  minFontSize: 10.0,
                ),
                if (detalle.isNotEmpty) ...[
                  const SizedBox(height: 6.0),
                  AutoSizeText(
                    detalle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 2,
                    minFontSize: 9.0,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
