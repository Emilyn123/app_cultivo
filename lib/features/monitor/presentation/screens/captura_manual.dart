import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CapturaManualSuelo extends StatefulWidget {
  const CapturaManualSuelo({super.key});

  @override
  State<CapturaManualSuelo> createState() => _CapturaManualSueloState();
}

class _CapturaManualSueloState extends State<CapturaManualSuelo> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _estaGuardando = false;

  // Controladores para los 4 parámetros físicos
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _humedadController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _ceController = TextEditingController();

  // Variables para el despliegue de opciones geográficas
  String? _estadoSeleccionado;
  String? _municipioSeleccionado;
  String? _localidadSeleccionada;

  // Listas de ejemplo para los Dropdowns (Catálogos)
  final List<String> _estados = ['Yucatán', 'Quintana Roo', 'Campeche'];
  final List<String> _municipios = ['Tizimín', 'Valladolid', 'Mérida'];
  final List<String> _localidades = [
    'Centro',
    'Traspatio Lote 1',
    'Zona Norte',
  ];

  Future<void> _guardarEnBaseDeDatos() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _estaGuardando = true);

      try {
        // Obtenemos el ID del usuario actual logueado
        final String? idUsuario = _supabase.auth.currentUser?.id;

        // Inserción directa a tu tabla de hechos en Supabase
        await _supabase.from('fact_medicion').insert({
          'id_usuario': idUsuario,
          'ph_medido': double.parse(_phController.text.trim()),
          'humedad_medida': double.parse(_humedadController.text.trim()),
          'temp_medida': double.parse(_tempController.text.trim()),
          'ce_medida': double.parse(_ceController.text.trim()),
          'estado': _estadoSeleccionado,
          'municipio': _municipioSeleccionado,
          'localidad': _localidadSeleccionada,
          // La fecha_registro y las llaves internas se generarán automáticamente en Supabase
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Datos guardados exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Regresa al menú anterior tras guardar
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al conectar con la base de datos: $e'),
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
      appBar: AppBar(
        title: const Text(
          'Captura Manual',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: 20,
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
                            const Text(
                              'Datos Geográficos',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Despliegues geográficos
                            _crearDropdown(
                              hint: 'Selecciona el Estado',
                              items: _estados,
                              value: _estadoSeleccionado,
                              onChanged: (val) =>
                                  setState(() => _estadoSeleccionado = val),
                            ),
                            const SizedBox(height: 10),
                            _crearDropdown(
                              hint: 'Selecciona el Municipio',
                              items: _municipios,
                              value: _municipioSeleccionado,
                              onChanged: (val) =>
                                  setState(() => _municipioSeleccionado = val),
                            ),
                            const SizedBox(height: 10),
                            _crearDropdown(
                              hint: 'Selecciona la Localidad/Lote',
                              items: _localidades,
                              value: _localidadSeleccionada,
                              onChanged: (val) =>
                                  setState(() => _localidadSeleccionada = val),
                            ),

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
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _crearCampoTexto(
                                    'CE (dS/m)',
                                    _ceController,
                                    Icons.bolt_outlined,
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
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _crearCampoTexto(
                                    'Humedad (%)',
                                    _humedadController,
                                    Icons.water_drop_outlined,
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
                                  backgroundColor: const Color(0xFF388E3C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: _estaGuardando
                                    ? null
                                    : _guardarEnBaseDeDatos,
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
    );
  }

  // --- Widget Auxiliar para Dropdowns (Estilo Cristal) ---
  Widget _crearDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
      ),
      dropdownColor: const Color(0xFF1B3B22), // Fondo del menú desplegado
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
      style: const TextStyle(color: Colors.white),
      hint: Text(hint, style: const TextStyle(color: Colors.white54)),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Campo requerido' : null,
    );
  }

  // --- Widget Auxiliar para Cajas de Texto Numéricas ---
  Widget _crearCampoTexto(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Falta';
        if (double.tryParse(value) == null) return 'Inválido';
        return null;
      },
    );
  }
}
