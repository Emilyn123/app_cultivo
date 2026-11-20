import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/widgets/tarjeta_comparacion.dart';
import '../../../crops/domain/etapa_cultivo.dart';
import '../../domain/siembra.dart';
import '../../../monitor/presentation/screens/captura_manual.dart';

class DetalleEtapaSeguimiento extends StatefulWidget {
  final Siembra siembra;
  final int etapaInicial;

  const DetalleEtapaSeguimiento({
    super.key,
    required this.siembra,
    this.etapaInicial = 0,
  });

  @override
  State<DetalleEtapaSeguimiento> createState() =>
      _DetalleEtapaSeguimientoState();
}

class _DetalleEtapaSeguimientoState extends State<DetalleEtapaSeguimiento> {
  late PageController _pageController;
  late int _etapaActual;

  // Guarda las lecturas separadas por clave de etapa ('siembra', 'germinacion', etc.)
  Map<String, List<String>> _lecturasPorEtapa = {};

  static const List<String> _datosVacios = [
    'PH: .....',
    'CE: .....',
    'TEMP: .....',
    'HUMEDAD: .....',
  ];

  List<EtapaCultivo> get _etapas => widget.siembra.cultivo.etapas;

  @override
  void initState() {
    super.initState();
    _etapaActual = widget.etapaInicial.clamp(0, _etapas.length - 1);
    _pageController = PageController(initialPage: _etapaActual);
    _cargarLecturasPorEtapa();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _cargarLecturasPorEtapa() async {
    final db = await DatabaseService.instance.database;
    final resultados = await db.query(
      'registros_manuales_pendientes',
      where: 'nombre_muestra = ?',
      whereArgs: [widget.siembra.nombre],
      orderBy: 'fecha_registro ASC',
    );

    final Map<String, List<String>> mapa = {};
    for (final data in resultados) {
      final String clave = (data['etapa_clave'] as String?) ?? 'siembra';
      mapa[clave] = [
        'PH: ${data['ph_medido']}',
        'CE: ${data['ce_medida']} dS/m',
        'TEMP: ${data['temp_medida']}°C',
        'HUMEDAD: ${data['humedad_medida']}%',
      ];
    }

    if (mounted) {
      setState(() {
        _lecturasPorEtapa = mapa;
      });
    }
  }

  List<String> _obtenerRequerimientosReales(EtapaCultivo etapa) {
    final ph = widget.siembra.cultivo.ph;

    return [
      'PH: ${ph.min} - ${ph.max}',
      'CE: ${etapa.ce.min} - ${etapa.ce.max} dS/m',
      'TEMP: ${etapa.temperatura.min} - ${etapa.temperatura.max}°C',
      'HUMEDAD: ${etapa.humedad.min} - ${etapa.humedad.max}%',
    ];
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
    final Size tamanoPantalla = MediaQuery.of(context).size;
    final String carpeta = widget.siembra.cultivo.carpetaImagenes;
    final List<String> nombresEtapas = _etapas
        .map((e) => e.nombre.toUpperCase())
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: tamanoPantalla.width,
        height: tamanoPantalla.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
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
                    Image.asset(
                      RutasImagenes.fondo(carpeta, etapa.clave),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: const Color(0xFF131A15)),
                    ),
                    Container(color: Colors.black.withOpacity(0.35)),
                    SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
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
                                const SizedBox(height: 10.0),
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
                                _BarraProgresoEtapas(
                                  etapas: nombresEtapas,
                                  etapaActual: _etapaActual,
                                  alTocarEtapa: _irAEtapa,
                                ),
                                const SizedBox(height: 26),
                                TarjetaComparacion(
                                  titulo: 'REQUERIMIENTOS\nNECESARIOS',
                                  imagenPath: RutasImagenes.ilustracion(
                                    carpeta,
                                    etapa.clave,
                                  ),
                                  datos: _obtenerRequerimientosReales(etapa),
                                  imagenALaDerecha: false,
                                ),
                                const SizedBox(height: 18),
                                TarjetaComparacion(
                                  titulo: 'TU SUELO',
                                  imagenPath: RutasImagenes.tierra,
                                  datos:
                                      _lecturasPorEtapa[etapa.clave] ??
                                      _datosVacios,
                                  imagenALaDerecha: false,
                                ),
                                const SizedBox(height: 24),
                                if (_etapaActual == 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.greenAccent.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.greenAccent,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Parámetros iniciales registrados',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CapturaManualSuelo(
                                                siembra: widget.siembra,
                                                etapaCultivo:
                                                    _etapas[_etapaActual],
                                              ),
                                        ),
                                      );
                                      _cargarLecturasPorEtapa();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.greenAccent.shade700,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: const Text(
                                      'VERIFICAR PARÁMETROS',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 40),
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
