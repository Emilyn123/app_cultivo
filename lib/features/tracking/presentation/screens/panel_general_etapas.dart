import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
// Importa la pantalla de detalle que creamos antes para poder navegar a ella
import 'detalle_etapas_cultivo.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';

class PanelGeneralEtapas extends StatelessWidget {
  const PanelGeneralEtapas({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de datos basada exactamente en tu imagen "guia de seguimiento_2.jpg"
    final List etapas = [
      {
        'titulo': '1.Siembra',
        'descripcion': 'Comienza con semillas de calidad en tierra fértil',
        'detalle': 'Profundidad: 1 cm | Riego: ligero',
        'icono': 'assets/images/follow-up/s_siembra.png',
      },
      {
        'titulo': '2.Germinación',
        'descripcion': 'Cotiledones aparecen y se generan las primeras raíces',
        'detalle': '',
        'icono': 'assets/images/follow-up/s_germ.png',
      },
      {
        'titulo': '3.Crecimiento vegetativo',
        'descripcion': 'Crecimiento vigoroso de las primeras hojas verdaderas',
        'detalle': 'Luz de sol: Alta | Humedad: Moderada',
        'icono': 'assets/images/follow-up/s_creci.png',
      },
      {
        'titulo': '4.Amarre del fruto',
        'descripcion': 'Aparición de flores y los primeros frutos',
        'detalle': '',
        'icono': 'assets/images/follow-up/s_amarre.png',
      },
      {
        'titulo': '5.Maduración',
        'descripcion': '¡Tomates listos! Cosecha cuando se encuentren rojos.',
        'detalle': '',
        'icono': 'assets/images/follow-up/s_maduracion.png',
      },
    ];

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
            Image.asset('assets/images/follow-up/campo.png', fit: BoxFit.cover),

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

                        // En lugar de ...etapas.map((etapa) { ... })
                        ...List.generate(etapas.length, (index) {
                          final etapa = etapas[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleEtapaSeguimiento(
                                      etapaInicial:
                                          index, // Pasa 0 para Siembra, 1 para Germinación, etc.
                                    ),
                                  ),
                                );
                              },
                              child: _TarjetaEtapa(
                                titulo: etapa['titulo']!,
                                descripcion: etapa['descripcion']!,
                                detalle: etapa['detalle']!,
                                rutaImagen: etapa['icono']!,
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
    // Calcula tamaños de fuente proporcionales

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
          // Imagen ilustrativa de la etapa
          Image.asset(
            rutaImagen,
            width: tamanoIcono,
            height: tamanoIcono,
            fit: BoxFit.contain,
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
                  maxLines: 3, // Fuerza a que el título entre en una sola línea
                  minFontSize:
                      10.0, // Si la pantalla es angosta, reducirá hasta 14px
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
                    maxLines:
                        2, // Fuerza a que el título entre en una sola línea
                    minFontSize:
                        9.0, // Si la pantalla es angosta, reducirá hasta 14px
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
