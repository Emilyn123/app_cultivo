import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../../core/services/database_service.dart';
import '../../domain/servicio_diagnostico.dart';
import '../../../crops/presentation/screens/comparacion_cultivo.dart';

class CapturaManualSuelo extends StatefulWidget {
  // Variables que recibe de la pantalla RegistroLoteScreen
  final int idCultivoEsperado;
  final String nombreMuestra;
  final String estado;
  final String municipio;
  final String localidad;

  const CapturaManualSuelo({
    super.key,
    required this.idCultivoEsperado,
    required this.nombreMuestra,
    required this.estado,
    required this.municipio,
    required this.localidad,
  });

  @override
  State<CapturaManualSuelo> createState() => _CapturaManualSueloState();
}

class _CapturaManualSueloState extends State<CapturaManualSuelo> {
  final _formKey = GlobalKey<FormState>();
  //final SupabaseClient _supabase = Supabase.instance.client;
  bool _estaGuardando = false;

  // Controladores para los 4 parámetros físicos
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _humedadController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _ceController = TextEditingController();

  Future<void> _guardarOffline() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _estaGuardando = true);

      try {
        // Obtenemos el ID del usuario actual logueado
        final db = await DatabaseService.instance.database;

        // Inserción directa a tu tabla de hechos en Supabase
        await db.insert('registros_manuales_pendientes', {
          'id_cultivo_esperado':
              widget.idCultivoEsperado, // Dato de la pantalla 1
          'nombre_muestra': widget.nombreMuestra, // Dato de la pantalla 2
          'estado': widget.estado, // Dato de la pantalla 2
          'municipio': widget.municipio, // Dato de la pantalla 2
          'localidad': widget.localidad, // Dato de la pantalla 2
          'ph_medido': _leerNumero(_phController),
          'humedad_medida': _leerNumero(_humedadController),
          'temp_medida': _leerNumero(_tempController),
          'ce_medida': _leerNumero(_ceController),
          'fecha_registro': DateTime.now().toIso8601String(),
          'sincronizado': 0,
        });

        //
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guardado localmente. Evaluando tierra...'),
              backgroundColor: Colors.green,
            ),
          );

          // 1. Mandamos los datos al Cerebro Matemático
          final diagnostico = ServicioDiagnostico.evaluarSuelo(
            idCultivo: widget.idCultivoEsperado,
            temp: double.parse(_tempController.text.trim()),
            humedad: double.parse(_humedadController.text.trim()),
            ph: double.parse(_phController.text.trim()),
            ce: double.parse(_ceController.text.trim()),
          );

          // 2. Navegamos a la pantalla de Comparación pasándole el resultado
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ComparacionCultivo(
                idCultivo: widget.idCultivoEsperado,
                resultado: diagnostico,
                ph: double.parse(_phController.text.trim()),
                ce: double.parse(_ceController.text.trim()),
                temp: double.parse(_tempController.text.trim()),
                humedad: double.parse(_humedadController.text.trim()),
              ),
            ),
          );
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
          // 1. Imagen de Fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),

          // 2. Filtro oscuro para contraste
          Container(color: Colors.black.withOpacity(0.5)),

          // 3. Formulario principal con efecto Cristal
          SafeArea(
            child: Column(
              children: [
                // --- ENCABEZADO PERSONALIZADO ---
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
                                    'Lote: ${widget.nombreMuestra}',
                                    style: TextStyle(
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

                                  // Campos de texto para mediciones
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

                                  // Botón de Guardar
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

  // Convierte el valor a double y acepta tanto punto como coma decimal.
  // La validación del formulario se ejecuta antes de llegar a esta función.
  double _leerNumero(TextEditingController controller) {
    return double.parse(controller.text.trim().replaceAll(',', '.'));
  }

  // --- Widget auxiliar para las cajas numéricas ---
  // Los límites y decimales se indican individualmente en cada llamada.
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
      // Solo permite números, un separador decimal y, cuando corresponde,
      // el signo menos al inicio. También limita los decimales permitidos.
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

        // Exige al menos un dígito antes del separador y otro después.
        // Acepta punto o coma como separador decimal.
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
