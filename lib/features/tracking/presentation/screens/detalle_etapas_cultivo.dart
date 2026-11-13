import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/widgets/tarjeta_comparacion.dart';
import '../../../crops/domain/cultivo.dart';
import '../../../crops/domain/etapa_cultivo.dart';

class DetalleEtapaSeguimiento extends StatefulWidget {
  final Cultivo cultivo;
  final int etapaInicial;

  const DetalleEtapaSeguimiento({
    super.key,
    required this.cultivo,
    this.etapaInicial = 0,
  });

  @override
  State<DetalleEtapaSeguimiento> createState() =>
      _DetalleEtapaSeguimientoState();
}

class _DetalleEtapaSeguimientoState extends State<DetalleEtapaSeguimiento> {
  late PageController _pageController;
  late int _etapaActual;

  // Pendiente: más adelante saldrá de la última lectura de suelo del usuario.
  static const List<String> _datosSueloPendientes = [
    'PH: .....',
    'CE: .....',
    'TEMP: .....',
    'HUMEDAD: .....',
  ];

  List<EtapaCultivo> get _etapas => widget.cultivo.etapas;

  @override
  void initState() {
    super.initState();
    _etapaActual = widget.etapaInicial.clamp(0, _etapas.length - 1);
    _pageController = PageController(initialPage: _etapaActual);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _irAEtapa(int indice) {
    _pageController.animateToPage(
      indice,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. MediaQuery: Consulta las dimensiones exactas del dispositivo
    final Size tamanoPantalla = MediaQuery.of(context).size;
    final String carpeta = widget.cultivo.carpetaImagenes;
    final List<String> nombresEtapas =
        _etapas.map((e) => e.nombre.toUpperCase()).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      // 2. SizedBox: Asegura que el contenedor abarque el 100% de la pantalla
      body: SizedBox(
        width: tamanoPantalla.width,
        height: tamanoPantalla.height,
        // 3. Stack con fit: StackFit.expand: Fuerza a las capas a expandirse por completo
        child: Stack(
          fit: StackFit.expand,
          children: [
            // PageView que permite deslizar entre las etapas
            PageView.builder(
              controller: _pageController,
              itemCount: _etapas.length,
              onPageChanged: (nuevoIndice) {
                setState(() {
                  _etapaActual = nuevoIndice;
                });
              },
              itemBuilder: (context, index) {
                final EtapaCultivo etapa = _etapas[index];

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Capa de fondo: Imagen de la maceta correspondiente a la etapa
                    Image.asset(
                      RutasImagenes.fondo(carpeta, etapa.clave),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: const Color(0xFF131A15)),
                    ),

                    // Capa de contraste oscura
                    Container(color: Colors.black.withOpacity(0.35)),

                    // Capa de contenido desplazable
                    SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Uso de clamp en el ancho del cartel colgante
                          final double anchoCartel =
                              (constraints.maxWidth * 0.52).clamp(160.0, 240.0);

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05,
                              vertical: 10.0,
                            ),
                            child: Column(
                              children: [
                                // Espacio superior para que el cartel no choque con la flecha de regreso
                                const SizedBox(height: 10.0),

                                // Cartel de madera con clamp en dimensiones.
                                // Si el cultivo aún no tiene su letrero, muestra el nombre.
                                Image.asset(
                                  RutasImagenes.letrero(carpeta, etapa.clave),
                                  width: anchoCartel,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Text(
                                    'Etapa: ${etapa.nombre}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Barra interactiva de pasos con AutoSizeText
                                _BarraProgresoEtapas(
                                  etapas: nombresEtapas,
                                  etapaActual: _etapaActual,
                                  alTocarEtapa: _irAEtapa,
                                ),

                                const SizedBox(height: 26),

                                // Tarjeta 1: Requerimientos necesarios
                                TarjetaComparacion(
                                  titulo: 'REQUERIMIENTOS\nNECESARIOS',
                                  imagenPath: RutasImagenes.ilustracion(
                                    carpeta,
                                    etapa.clave,
                                  ),
                                  datos: widget.cultivo
                                      .requerimientosEtapa(etapa),
                                  imagenALaDerecha: false,
                                ),

                                const SizedBox(height: 18),

                                // Tarjeta 2: Tu suelo
                                TarjetaComparacion(
                                  titulo: 'TU SUELO',
                                  imagenPath: RutasImagenes.tierra,
                                  datos: _datosSueloPendientes,
                                  imagenALaDerecha: false,
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            // 2. Botón flotante de regreso (diseño sutil translúcido)
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraProgresoEtapas extends StatelessWidget {
  final List<String> etapas;
  final int etapaActual;
  final Function(int) alTocarEtapa;

  const _BarraProgresoEtapas({
    required this.etapas,
    required this.etapaActual,
    required this.alTocarEtapa,
  });

  @override
  Widget build(BuildContext context) {
    const Color colorActivo = Color(0xFF55E7D8);
    const Color colorInactivo = Colors.white30;

    return Column(
      children: [
        // Línea y círculos de conexión
        Row(
          children: List.generate(etapas.length * 2 - 1, (index) {
            if (index.isEven) {
              final int nodoIndex = index ~/ 2;
              final bool esActivo = nodoIndex <= etapaActual;
              final bool esActual = nodoIndex == etapaActual;

              return GestureDetector(
                onTap: () => alTocarEtapa(nodoIndex),
                child: Container(
                  width: esActual ? 14 : 10,
                  height: esActual ? 14 : 10,
                  decoration: BoxDecoration(
                    color: esActivo ? colorActivo : colorInactivo,
                    shape: BoxShape.circle,
                    boxShadow: esActual
                        ? [
                            const BoxShadow(
                              color: colorActivo,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }

            final int lineaSegmentoIndex = index ~/ 2;
            final bool lineaActiva = lineaSegmentoIndex < etapaActual;

            return Expanded(
              child: Container(
                height: 2.0,
                color: lineaActiva ? colorActivo : colorInactivo,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),

        // Textos inferiores con AutoSizeText
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(etapas.length, (index) {
            final bool esActivo = index <= etapaActual;
            final bool esActual = index == etapaActual;

            return Expanded(
              child: GestureDetector(
                onTap: () => alTocarEtapa(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: AutoSizeText(
                    etapas[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8.0,
                      fontWeight: esActual ? FontWeight.w800 : FontWeight.w600,
                      color: esActivo ? Colors.white : Colors.white38,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 2,
                    minFontSize: 5.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
