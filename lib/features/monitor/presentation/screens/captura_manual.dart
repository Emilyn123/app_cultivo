import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/servicio_diagnostico.dart';
import '../../../crops/presentation/screens/comparacion_cultivo.dart';
import 'resultados_recomendacion.dart';
import '../../../tracking/domain/siembra.dart';
import '../../../crops/domain/etapa_cultivo.dart';

class CapturaManualSuelo extends StatefulWidget {
  final int? idCultivoEsperado;
  final String? nombreMuestra;
  final String? estado;
  final String? municipio;
  final String? localidad;
  final Siembra? siembra;
  final EtapaCultivo? etapaCultivo;

  const CapturaManualSuelo({
    super.key,
    this.idCultivoEsperado,
    this.nombreMuestra,
    this.estado,
    this.municipio,
    this.localidad,
    this.siembra,
    this.etapaCultivo,
  });

  @override
  State<CapturaManualSuelo> createState() => _CapturaManualSueloState();
}

class _CapturaManualSueloState extends State<CapturaManualSuelo> {
  final _formKey = GlobalKey<FormState>();
  bool _estaGuardando = false;

  final TextEditingController _phController = TextEditingController();
  final TextEditingController _humedadController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _ceController = TextEditingController();

  void _mostrarDialogoResultado(
    BuildContext context,
    String titulo,
    String mensaje,
    bool esExito,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3B22).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: esExito
                        ? Colors.greenAccent.withOpacity(0.5)
                        : Colors.redAccent.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            titulo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context); // 1. Cierra el diálogo
                            Navigator.pop(
                              context,
                            ); // 2. Regresa a detalle_etapas
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 10),
                    Icon(
                      esExito
                          ? Icons.check_circle_outline
                          : Icons.warning_amber_rounded,
                      color: esExito ? Colors.greenAccent : Colors.redAccent,
                      size: 65,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      mensaje,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _guardarOffline() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _estaGuardando = true);

      try {
        final db = await DatabaseService.instance.database;

        final double phMedido = _leerNumero(_phController);
        final double humedadMedida = _leerNumero(_humedadController);
        final double tempMedida = _leerNumero(_tempController);
        final double ceMedida = _leerNumero(_ceController);

        // 1. Valores por defecto o recibidos en flujo normal
        int idCultivoFinal = widget.idCultivoEsperado ?? 0;
        String estadoFinal = widget.estado ?? '';
        String municipioFinal = widget.municipio ?? '';
        String localidadFinal = widget.localidad ?? '';
        String loteFinal =
            widget.siembra?.nombre ?? widget.nombreMuestra ?? 'Seguimiento';

        // 2. Si estamos en MODO SEGUIMIENTO, heredamos los datos originales del lote
        if (widget.siembra != null) {
          final lecturaAnterior = await db.query(
            'registros_manuales_pendientes',
            where: 'nombre_muestra = ?',
            whereArgs: [loteFinal],
            orderBy: 'fecha_registro ASC',
            limit: 1,
          );

          if (lecturaAnterior.isNotEmpty) {
            final data = lecturaAnterior.first;
            idCultivoFinal =
                (data['id_cultivo_esperado'] as int?) ?? idCultivoFinal;
            estadoFinal = (data['estado'] as String?) ?? estadoFinal;
            municipioFinal = (data['municipio'] as String?) ?? municipioFinal;
            localidadFinal = (data['localidad'] as String?) ?? localidadFinal;
          }
        }

        // 3. Guardado local en SQLite con etapa_clave y sin campos nulos
        await db.insert('registros_manuales_pendientes', {
          'id_cultivo_esperado': idCultivoFinal,
          'nombre_muestra': loteFinal,
          'estado': estadoFinal,
          'municipio': municipioFinal,
          'localidad': localidadFinal,
          'etapa_clave': widget.etapaCultivo?.clave ?? 'siembra',
          'ph_medido': phMedido,
          'humedad_medida': humedadMedida,
          'temp_medida': tempMedida,
          'ce_medida': ceMedida,
          'fecha_registro': DateTime.now().toIso8601String(),
          'sincronizado': 0,
        });

        if (mounted) {
          // --- MODO 1: Seguimiento de Etapa ---
          if (widget.siembra != null && widget.etapaCultivo != null) {
            final etapa = widget.etapaCultivo!;
            final phOptimo = widget.siembra!.cultivo.ph;

            bool pasaPh = phMedido >= phOptimo.min && phMedido <= phOptimo.max;
            bool pasaCe = ceMedida >= etapa.ce.min && ceMedida <= etapa.ce.max;
            bool pasaTemp =
                tempMedida >= etapa.temperatura.min &&
                tempMedida <= etapa.temperatura.max;
            bool pasaHum =
                humedadMedida >= etapa.humedad.min &&
                humedadMedida <= etapa.humedad.max;

            bool esExito = pasaPh && pasaCe && pasaTemp && pasaHum;
            String titulo = esExito
                ? '¡Etapa superada!'
                : 'Alerta de parámetros';
            String mensaje = esExito
                ? 'Tus parámetros de suelo cumplen a la perfección con la etapa de ${etapa.nombre}. ¡Buen trabajo!'
                : 'Cuidado: Tienes parámetros fuera de rango para la etapa de ${etapa.nombre}. Revisa las necesidades de tu planta.';

            _mostrarDialogoResultado(context, titulo, mensaje, esExito);
            return;
          }

          // --- MODO 2: Flujo de Recomendación (ID = 0) ---
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guardado localmente. Evaluando tierra...'),
              backgroundColor: Colors.green,
            ),
          );

          if (idCultivoFinal == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultadosRecomendacionScreen(
                  nombreMuestra: loteFinal,
                  ph: phMedido,
                  ce: ceMedida,
                  temp: tempMedida,
                  humedad: humedadMedida,
                ),
              ),
            );
          } else {
            // --- MODO 3: Flujo de Nuevo Cultivo ---
            final diagnostico = ServicioDiagnostico.evaluarSuelo(
              idCultivo: idCultivoFinal,
              temp: tempMedida,
              humedad: humedadMedida,
              ph: phMedido,
              ce: ceMedida,
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ComparacionCultivo(
                  idCultivo: idCultivoFinal,
                  nombreMuestra: loteFinal,
                  resultado: diagnostico,
                  ph: phMedido,
                  ce: ceMedida,
                  temp: tempMedida,
                  humedad: humedadMedida,
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _estaGuardando = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _phController.dispose();
    _humedadController.dispose();
    _tempController.dispose();
    _ceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Column(
              children: [
                const EncabezadoPersonalizado(titulo: 'Ingresa tus Datos'),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(25.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B3B22).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Lote: ${widget.siembra?.nombre ?? widget.nombreMuestra ?? 'Sin nombre'}',
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(
                                    color: Colors.white24,
                                    height: 40,
                                    thickness: 1,
                                  ),
                                  const Text(
                                    'Parámetros del Suelo',
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _crearCampoTexto(
                                          'pH',
                                          _phController,
                                          Icons.science_outlined,
                                          minimo: 0,
                                          maximo: 14,
                                          decimales: 2,
                                          ejemplo: '7.25',
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _crearCampoTexto(
                                          'CE (dS/m)',
                                          _ceController,
                                          Icons.bolt_outlined,
                                          minimo: 0,
                                          maximo: 100,
                                          decimales: 2,
                                          ejemplo: '1.25',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _crearCampoTexto(
                                          'Temp (°C)',
                                          _tempController,
                                          Icons.thermostat_outlined,
                                          minimo: -50,
                                          maximo: 100,
                                          decimales: 1,
                                          permiteNegativos: true,
                                          ejemplo: '25.5',
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _crearCampoTexto(
                                          'Humedad (%)',
                                          _humedadController,
                                          Icons.water_drop_outlined,
                                          minimo: 0,
                                          maximo: 100,
                                          decimales: 1,
                                          ejemplo: '45.5',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF388E3C,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),
                                      onPressed: _estaGuardando
                                          ? null
                                          : _guardarOffline,
                                      child: _estaGuardando
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              'GUARDAR LECTURA',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }

  double _leerNumero(TextEditingController controller) {
    return double.parse(controller.text.trim().replaceAll(',', '.'));
  }

  Widget _crearCampoTexto(
    String label,
    TextEditingController controller,
    IconData icon, {
    required double minimo,
    required double maximo,
    required int decimales,
    required String ejemplo,
    bool permiteNegativos = false,
  }) {
    final patronEntrada = permiteNegativos
        ? RegExp(r'^-?\d*(?:[.,]\d*)?$')
        : RegExp(r'^\d*(?:[.,]\d*)?$');

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: permiteNegativos,
      ),
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          final texto = newValue.text;
          if (!patronEntrada.hasMatch(texto)) return oldValue;

          final separador = texto.contains('.') ? '.' : ',';
          final cantidadDecimales = texto.contains(separador)
              ? texto.split(separador).last.length
              : 0;

          if (cantidadDecimales > decimales) return oldValue;
          return newValue;
        }),
      ],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        helperText:
            '${minimo.toStringAsFixed(0)}–${maximo.toStringAsFixed(0)} · máx. $decimales dec.',
        helperStyle: const TextStyle(color: Colors.white60, fontSize: 10),
        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
        errorMaxLines: 2,
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        final texto = value?.trim() ?? '';
        if (texto.isEmpty) {
          return 'Dato obligatorio. Ej.: $ejemplo';
        }

        final formatoValido = permiteNegativos
            ? RegExp(r'^-?\d+(?:[.,]\d+)?$')
            : RegExp(r'^\d+(?:[.,]\d+)?$');

        if (!formatoValido.hasMatch(texto)) {
          return 'Formato incorrecto. Ej.: $ejemplo';
        }

        final separador = texto.contains('.') ? '.' : ',';
        final cantidadDecimales = texto.contains(separador)
            ? texto.split(separador).last.length
            : 0;

        if (cantidadDecimales > decimales) {
          return 'Usa máximo $decimales decimales. Ej.: $ejemplo';
        }

        final numero = double.tryParse(texto.replaceAll(',', '.'));
        if (numero == null || !numero.isFinite) {
          return 'Número no válido. Ej.: $ejemplo';
        }

        if (numero < minimo || numero > maximo) {
          return 'Fuera de rango: ${minimo.toStringAsFixed(0)} a ${maximo.toStringAsFixed(0)}.';
        }

        return null;
      },
    );
  }
}
