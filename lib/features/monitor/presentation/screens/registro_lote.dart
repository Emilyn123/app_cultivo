import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import 'captura_manual.dart';

class RegistroLoteScreen extends StatefulWidget {
  // Recibe el cultivo que el usuario eligió en la pantalla anterior
  final int idCultivoEsperado;

  const RegistroLoteScreen({super.key, required this.idCultivoEsperado});

  @override
  State<RegistroLoteScreen> createState() => _RegistroLoteScreenState();
}

class _RegistroLoteScreenState extends State<RegistroLoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreMuestraController =
      TextEditingController();

  String? _estadoSeleccionado;
  String? _municipioSeleccionado;
  String? _localidadSeleccionada;

  // Catálogo geográfico en cascada: Estado -> Municipio -> Localidades
  final Map<String, Map<String, List<String>>> _catalogo = {
    'Yucatán': {
      'Mérida': ['Centro', 'Caucel', 'Chuburná'],
      'Tizimín': ['Centro', 'Colonia Yucatán'],
      'Valladolid': ['Centro', 'Ebtún'],
    },
    'Quintana Roo': {
      'Felipe Carrillo Puerto': ['Centro', 'Chunhuhub'],
    },
    'Campeche': {
      'Campeche': ['Centro', 'Lerma'],
    },
  };

  List<String> get _estados => _catalogo.keys.toList();

  List<String> get _municipios => _estadoSeleccionado == null
      ? []
      : _catalogo[_estadoSeleccionado]!.keys.toList();

  List<String> get _localidades => _municipioSeleccionado == null
      ? []
      : _catalogo[_estadoSeleccionado]![_municipioSeleccionado]!;

  void _continuar() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CapturaManualSuelo(
            idCultivoEsperado: widget.idCultivoEsperado,
            nombreMuestra: _nombreMuestraController.text.trim(),
            estado: _estadoSeleccionado!,
            municipio: _municipioSeleccionado!,
            localidad: _localidadSeleccionada!,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nombreMuestraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Imagen de fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),

          // 2. Filtro oscuro
          Container(color: Colors.black.withOpacity(0.5)),

          // 3. Contenido
          SafeArea(
            child: Column(
              children: [
                const EncabezadoPersonalizado(titulo: 'Identificar Terreno'),
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
                                  const Text(
                                    'Detalles del Lote',
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Asigna un nombre para identificar este cuadrante en el futuro.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  _crearCampoNombre(),

                                  const Divider(
                                    color: Colors.white24,
                                    height: 40,
                                    thickness: 1,
                                  ),

                                  const Text(
                                    'Ubicación Geográfica',
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  // --- Dropdowns en cascada ---
                                  _crearDropdown(
                                    key: const ValueKey('estado'),
                                    hint: 'Selecciona el Estado',
                                    items: _estados,
                                    value: _estadoSeleccionado,
                                    onChanged: (val) => setState(() {
                                      _estadoSeleccionado = val;
                                      _municipioSeleccionado = null;
                                      _localidadSeleccionada = null;
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  _crearDropdown(
                                    key: ValueKey('mun_$_estadoSeleccionado'),
                                    hint: 'Selecciona el Municipio',
                                    items: _municipios,
                                    value: _municipioSeleccionado,
                                    onChanged: (val) => setState(() {
                                      _municipioSeleccionado = val;
                                      _localidadSeleccionada = null;
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  _crearDropdown(
                                    key: ValueKey(
                                      'loc_${_estadoSeleccionado}_$_municipioSeleccionado',
                                    ),
                                    hint: 'Selecciona la Localidad/Lote',
                                    items: _localidades,
                                    value: _localidadSeleccionada,
                                    onChanged: (val) => setState(
                                      () => _localidadSeleccionada = val,
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Botón Continuar
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
                                      onPressed: _continuar,
                                      child: const Text(
                                        'CONTINUAR',
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

  // Estilo común de los campos translúcidos
  InputDecoration _decoracionCristal({String? hint, IconData? icono}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: icono != null
          ? Icon(icono, color: Colors.white70, size: 20)
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  // Campo de texto para el nombre del cuadrante
  Widget _crearCampoNombre() {
    return TextFormField(
      controller: _nombreMuestraController,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: Colors.white),
      decoration: _decoracionCristal(
        hint: 'Nombre del Cuadrante',
        icono: Icons.landscape_outlined,
      ),
      validator: (val) =>
          val == null || val.trim().isEmpty ? 'Requerido' : null,
    );
  }

  // Dropdown con estilo cristal. La key reinicia el campo al cambiar el nivel superior.
  // Si no hay opciones (nivel anterior sin elegir), queda deshabilitado.
  Widget _crearDropdown({
    required Key key,
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      key: key,
      isExpanded: true,
      initialValue: value,
      hint: Text(
        hint,
        style: const TextStyle(
          color: Color.fromARGB(143, 255, 255, 255),
          fontSize: 16,
        ),
      ),

      disabledHint: Text(
        hint,
        style: const TextStyle(
          color: Color.fromARGB(143, 255, 255, 255),
          fontSize: 16,
        ),
      ),
      dropdownColor: const Color(0xFF1B3B22),
      iconEnabledColor: Colors.white70,
      iconDisabledColor: Colors.white24,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: _decoracionCristal(
        hint: hint,
      ).copyWith(hintStyle: const TextStyle(color: Colors.white, fontSize: 16)),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            ),
          )
          .toList(),
      onChanged: items.isEmpty ? null : onChanged,
      validator: (val) => val == null ? 'Requerido' : null,
    );
  }
}
