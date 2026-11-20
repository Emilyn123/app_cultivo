import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/fertilizacion.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';

class BitacoraFertilizacionScreen extends StatefulWidget {
  const BitacoraFertilizacionScreen({super.key});

  @override
  State<BitacoraFertilizacionScreen> createState() =>
      _BitacoraFertilizacionScreenState();
}

class _BitacoraFertilizacionScreenState
    extends State<BitacoraFertilizacionScreen> {
  List<Fertilizacion> _registros = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('fertilizacion_historial');

    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      setState(() {
        _registros = decoded
            .map((item) => Fertilizacion.fromJson(item))
            .toList();
      });
    }
    setState(() => _cargando = false);
  }

  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _registros.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('fertilizacion_historial', encoded);
  }

  void _agregarOEditar(Fertilizacion nuevo) {
    setState(() {
      final index = _registros.indexWhere((r) => r.id == nuevo.id);
      if (index >= 0) {
        _registros[index] = nuevo;
      } else {
        _registros.insert(0, nuevo);
      }
    });
    _guardarDatos();
  }

  void _eliminarRegistro(String id) {
    setState(() {
      _registros.removeWhere((r) => r.id == id);
    });
    _guardarDatos();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1E12),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fondo verde consistente con toda la app
          Image.asset(
            RutasImagenes.fondoCampo,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF0F1E12)),
          ),

          // 2. Capa oscura de contraste
          Container(color: Colors.black.withOpacity(0.50)),

          // 3. Contenido principal
          SafeArea(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.greenAccent),
                  )
                : Column(
                    children: [
                      // Encabezado reutilizable
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: 12.0,
                        ),
                        //encabezado
                        child: const SizedBox(
                          height: 100,
                          child: EncabezadoPersonalizado(
                            titulo: 'Fertilización Foliar',
                          ),
                        ),
                      ),

                      // Lista principal con el botón de Resumen debajo del historial
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            top: 8.0,
                            bottom:
                                100.0, // Espacio para que el FAB no tape nada
                          ),
                          children: [
                            const Text(
                              'Historial de Aplicaciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            if (_registros.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.08,
                                  horizontal: size.width * 0.05,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.eco_outlined,
                                      size: 56,
                                      color: Colors.white.withOpacity(0.35),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Aún no tienes aplicaciones registradas.\nToca "Nueva Aplicación" para añadir la primera.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ..._registros.map(
                                (reg) => _TarjetaFertilizacion(
                                  registro: reg,
                                  alEditar: () => _mostrarModalNuevoRegistro(
                                    context,
                                    registroAEditar: reg,
                                  ),
                                  alEliminar: () =>
                                      _confirmarEliminar(context, reg.id),
                                ),
                              ),

                            const SizedBox(height: 16),

                            // --- BOTÓN DE RESUMEN EN SU POSICIÓN ORIGINAL ---
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () => _mostrarResumen(context),
                                icon: const Icon(
                                  Icons.bar_chart_rounded,
                                  color: Colors.white,
                                ),
                                label: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Ver Resumen de Cantidades',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF388E3C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: Colors.greenAccent.withOpacity(
                                        0.35,
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
          ),
        ],
      ),

      // --- FLOATING ACTION BUTTON CON DISEÑO DE CRISTAL (GLASSMORPHISM) ---
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2E5325).withOpacity(0.55),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.greenAccent.withOpacity(0.45),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () => _mostrarModalNuevoRegistro(context),
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              icon: const Icon(Icons.add, color: Colors.greenAccent),
              label: const Text(
                'Nueva Aplicación',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2E1D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        title: const Text(
          '¿Eliminar registro?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Esta acción eliminará la aplicación del historial y no se puede deshacer.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _eliminarRegistro(id);
              Navigator.pop(context);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL ADAPTADO AL DISEÑO VERDE OSCURO / CRISTAL ---
  void _mostrarModalNuevoRegistro(
    BuildContext context, {
    Fertilizacion? registroAEditar,
  }) {
    final formKey = GlobalKey<FormState>();
    final productoController = TextEditingController(
      text: registroAEditar?.producto ?? '',
    );
    final cantidadController = TextEditingController(
      text: registroAEditar?.cantidad.toString() ?? '',
    );
    final notasController = TextEditingController(
      text: registroAEditar?.notas ?? '',
    );
    String unidadSeleccionada = registroAEditar?.unidad ?? 'ml';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final size = MediaQuery.of(context).size;

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: size.width * 0.05,
                right: size.width * 0.05,
                top: 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF162618),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.greenAccent.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons.eco,
                            color: Colors.greenAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                registroAEditar == null
                                    ? 'Registrar Aplicación Foliar'
                                    : 'Editar Aplicación Foliar',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: productoController,
                        style: const TextStyle(color: Colors.white),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Ingresa el nombre del fertilizante'
                            : null,
                        decoration: _decoracionCampo(
                          etiqueta: 'Fertilizante / Producto',
                          sugerencia: 'Ej. Humus líquido, Calcio-Boro, NPK...',
                          icono: Icons.science_outlined,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: cantidadController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              style: const TextStyle(color: Colors.white),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Ingresa la dosis';
                                }
                                final numVal = double.tryParse(
                                  val.replaceAll(',', '.'),
                                );
                                if (numVal == null || numVal <= 0) {
                                  return 'Número inválido';
                                }
                                return null;
                              },
                              decoration: _decoracionCampo(
                                etiqueta: 'Dosis / Cantidad',
                                sugerencia: 'Ej. 250',
                                icono: Icons.scale_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: unidadSeleccionada,
                              dropdownColor: const Color(0xFF223521),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: _decoracionCampo(
                                etiqueta: 'Unidad',
                                sugerencia: '',
                              ),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => unidadSeleccionada = val);
                                }
                              },
                              items: ['ml', 'L', 'g', 'kg']
                                  .map(
                                    (u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(u),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: notasController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Especifica el cultivo y observaciones de aplicación'
                            : null,
                        decoration: _decoracionCampo(
                          etiqueta: 'Cultivo y Notas de Aplicación',
                          sugerencia:
                              'Especifica a qué cultivo se aplica, lote y etapa (ej. Tomate Rojo - Lote Sur, inicio de floración)',
                          icono: Icons.notes_rounded,
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF388E3C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          label: Text(
                            registroAEditar == null
                                ? 'Guardar Registro'
                                : 'Guardar Cambios',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final cantidadLimpia = double.parse(
                                cantidadController.text.trim().replaceAll(
                                  ',',
                                  '.',
                                ),
                              );

                              _agregarOEditar(
                                Fertilizacion(
                                  id:
                                      registroAEditar?.id ??
                                      DateTime.now().millisecondsSinceEpoch
                                          .toString(),
                                  producto: productoController.text.trim(),
                                  cantidad: cantidadLimpia,
                                  unidad: unidadSeleccionada,
                                  fechaHora:
                                      registroAEditar?.fechaHora ??
                                      DateTime.now(),
                                  notas: notasController.text.trim(),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _decoracionCampo({
    required String etiqueta,
    required String sugerencia,
    IconData? icono,
  }) {
    return InputDecoration(
      labelText: etiqueta,
      labelStyle: const TextStyle(color: Colors.greenAccent, fontSize: 13.5),
      hintText: sugerencia,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 12.5),
      hintMaxLines: 2,
      prefixIcon: icono != null
          ? Icon(icono, color: Colors.white70, size: 20)
          : null,
      filled: true,
      fillColor: const Color(0xFF223521).withOpacity(0.92),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.greenAccent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  // --- DIÁLOGO DE RESUMEN ESTILIZADO ---
  void _mostrarResumen(BuildContext context) {
    final Map<String, double> resumen = {};
    for (var reg in _registros) {
      String clave = '${reg.producto} (${reg.unidad})';
      resumen[clave] = (resumen[clave] ?? 0) + reg.cantidad;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2E1D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.greenAccent.withOpacity(0.3)),
        ),
        title: const Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: Colors.greenAccent),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Resumen de Insumos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: resumen.isEmpty
            ? const Text(
                'No hay aplicaciones registradas para calcular totales.',
                style: TextStyle(color: Colors.white70),
              )
            : SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: resumen.entries.map((e) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF223521),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              e.key,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Text(
                            e.value.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaFertilizacion extends StatelessWidget {
  final Fertilizacion registro;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  const _TarjetaFertilizacion({
    required this.registro,
    required this.alEditar,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final fecha =
        '${registro.fechaHora.day.toString().padLeft(2, '0')}/${registro.fechaHora.month.toString().padLeft(2, '0')}/${registro.fechaHora.year} • ${registro.fechaHora.hour.toString().padLeft(2, '0')}:${registro.fechaHora.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF223521).withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.eco,
                  color: Colors.greenAccent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      registro.producto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dosis: ${registro.cantidad} ${registro.unidad}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.lightBlueAccent,
                  size: 21,
                ),
                tooltip: 'Editar',
                onPressed: alEditar,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 21,
                ),
                tooltip: 'Eliminar',
                onPressed: alEliminar,
              ),
            ],
          ),
          if (registro.notas != null && registro.notas!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                registro.notas!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Text(
                fecha,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
