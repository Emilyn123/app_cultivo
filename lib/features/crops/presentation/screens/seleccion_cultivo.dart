import 'package:flutter/material.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../../core/widgets/tarjeta_cultivo_elegir.dart';
import '../../../monitor/domain/servicio_diagnostico.dart';
import '../../../monitor/presentation/screens/registro_lote.dart';
import '../../../crops/presentation/screens/comparacion_cultivo.dart';

class SeleccionCultivo extends StatefulWidget {
  // Variables opcionales para el "Modo Recomendación"
  final bool esModoRecomendacion;
  final String? nombreMuestraPrevio;
  final double? phPrevio;
  final double? cePrevio;
  final double? tempPrevio;
  final double? humedadPrevio;
  final int? idCultivoDescartado;

  const SeleccionCultivo({
    super.key,
    this.esModoRecomendacion = false,
    this.nombreMuestraPrevio,
    this.phPrevio,
    this.cePrevio,
    this.tempPrevio,
    this.humedadPrevio,
    this.idCultivoDescartado,
  });

  @override
  State<SeleccionCultivo> createState() => _SeleccionCultivoState();
}

class _SeleccionCultivoState extends State<SeleccionCultivo> {
  late Future<List<Map<String, dynamic>>> _cultivosFuture;

  @override
  void initState() {
    super.initState();
    _cultivosFuture = _obtenerCultivos();
  }

  // Extrae el catálogo directamente desde la lógica central (servicio_diagnostico.dart)
  Future<List<Map<String, dynamic>>> _obtenerCultivos() async {
    // Si venimos del diagnóstico, filtramos los cultivos aptos
    if (widget.esModoRecomendacion) {
      return ServicioDiagnostico.recomendarAlternativas(
        ph: widget.phPrevio!,
        ce: widget.cePrevio!,
        temp: widget.tempPrevio!,
        humedad: widget.humedadPrevio!,
        idCultivoDescartado: widget.idCultivoDescartado!,
      );
    }
    // Flujo normal: Mostramos todo el catálogo
    return ServicioDiagnostico.obtenerCatalogoCultivos();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingLateral = (size.width * 0.05).clamp(14.0, 24.0);
    final espaciadoColumnas = (size.width * 0.04).clamp(12.0, 18.0);
    final separacionFilas = (size.height * 0.045).clamp(28.0, 44.0);
    final int columnas = size.width > 900 ? 4 : (size.width > 600 ? 3 : 2);
    final double proporcionAspecto = size.width > 600 ? 0.85 : 0.85;

    return Scaffold(
      backgroundColor: const Color(0xFF131E17),
      body: SafeArea(
        child: Column(
          children: [
            EncabezadoPersonalizado(
              titulo: widget.esModoRecomendacion
                  ? 'Cultivos Recomendados'
                  : 'Selecciona tu cultivo',
            ),
            Expanded(
              child: FutureBuilder<List>(
                future: _cultivosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        widget.esModoRecomendacion
                            ? 'Tu tierra actual no es apta para ningún cultivo del catálogo.'
                            : 'No hay cultivos disponibles',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final cultivos = snapshot.data!;

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingLateral,
                      vertical: 30.0,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      crossAxisSpacing: espaciadoColumnas,
                      mainAxisSpacing: separacionFilas,
                      childAspectRatio: proporcionAspecto,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: cultivos.length,
                    itemBuilder: (context, index) {
                      final cultivo = cultivos[index];

                      return TarjetaCultivoElegir(
                        imagenPath: cultivo['imagenPath'],
                        nombre: cultivo['nombre'],
                        alPresionar: () {
                          if (widget.esModoRecomendacion) {
                            // SALTO INTELIGENTE: Evaluamos y mandamos directo a la Alerta Verde
                            final diagnosticoExitoso =
                                ServicioDiagnostico.evaluarSuelo(
                                  idCultivo: cultivo['id_cultivo'],
                                  ph: widget.phPrevio!,
                                  ce: widget.cePrevio!,
                                  temp: widget.tempPrevio!,
                                  humedad: widget.humedadPrevio!,
                                );

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComparacionCultivo(
                                  idCultivo: cultivo['id_cultivo'],
                                  nombreMuestra: widget.nombreMuestraPrevio!,
                                  resultado: diagnosticoExitoso,
                                  ph: widget.phPrevio!,
                                  ce: widget.cePrevio!,
                                  temp: widget.tempPrevio!,
                                  humedad: widget.humedadPrevio!,
                                ),
                              ),
                              (Route<dynamic> route) => route
                                  .isFirst, // Limpia el historial para que no vuelva al error
                            );
                          } else {
                            // FLUJO NORMAL: Navegación al paso de registro de lote
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistroLoteScreen(
                                  idCultivoEsperado: cultivo['id_cultivo'],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
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
