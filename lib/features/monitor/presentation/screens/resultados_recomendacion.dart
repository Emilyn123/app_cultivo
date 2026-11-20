import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../domain/servicio_diagnostico.dart';
import '../../../crops/data/repositories/repositorio_siembras.dart';
import '../../../home/presentation/screens/menu_principal.dart';

class ResultadosRecomendacionScreen extends StatefulWidget {
  final String nombreMuestra;
  final double ph;
  final double ce;
  final double temp;
  final double humedad;

  const ResultadosRecomendacionScreen({
    super.key,
    required this.nombreMuestra,
    required this.ph,
    required this.ce,
    required this.temp,
    required this.humedad,
  });

  @override
  State<ResultadosRecomendacionScreen> createState() =>
      _ResultadosRecomendacionScreenState();
}

class _ResultadosRecomendacionScreenState
    extends State<ResultadosRecomendacionScreen> {
  late List<Map<String, dynamic>> _cultivosRecomendados;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cultivosRecomendados = ServicioDiagnostico.recomendarAlternativas(
      ph: widget.ph,
      ce: widget.ce,
      temp: widget.temp,
      humedad: widget.humedad,
      idCultivoDescartado: 0,
    );
  }

  Future<void> _iniciarSeguimiento(Map<String, dynamic> cultivo) async {
    setState(() => _guardando = true);

    try {
      final repositorio = RepositorioSiembras();

      await repositorio.registrarNuevaSiembra(
        idCultivo: cultivo['id_cultivo'],
        nombreCultivo: cultivo['nombre'],
        nombreMuestra: widget.nombreMuestra,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Seguimiento para ${cultivo['nombre']} iniciado con éxito!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MenuPrincipal()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar el cultivo.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _guardando = false);
      }
    }
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
                const EncabezadoPersonalizado(titulo: 'Opciones Ideales'),

                Expanded(
                  child: _cultivosRecomendados.isEmpty
                      ? const Center(
                          child: Text(
                            'Actualmente no hay cultivos en el catálogo\ncompatibles con estos parámetros.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                            vertical: 20,
                          ),
                          itemCount: _cultivosRecomendados.length,
                          itemBuilder: (context, index) {
                            final cultivo = _cultivosRecomendados[index];
                            return _TarjetaRecomendacionCristal(
                              nombreCultivo: cultivo['nombre'],
                              iconoPath:
                                  cultivo['iconoPath'] ??
                                  'assets/images/eco_icon.png',
                              justificacion:
                                  cultivo['justificacion'], // Pasamos el texto dinámico
                              estaGuardando: _guardando,
                              alPresionarIniciar: () =>
                                  _iniciarSeguimiento(cultivo),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET DE TARJETA DE CRISTAL OPTIMIZADA ---
class _TarjetaRecomendacionCristal extends StatelessWidget {
  final String nombreCultivo;
  final String iconoPath;
  final String justificacion;
  final bool estaGuardando;
  final VoidCallback alPresionarIniciar;

  const _TarjetaRecomendacionCristal({
    required this.nombreCultivo,
    required this.iconoPath,
    required this.justificacion,
    required this.estaGuardando,
    required this.alPresionarIniciar,
  });

  // Función para mostrar la ventana emergente con el texto completo
  void _mostrarDetalles(BuildContext context) {
    showDialog(
      context: context,
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
                    color: Colors.greenAccent.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Se adapta al contenido
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- ENVOLVER EL TEXTO EN UN EXPANDED ---
                        Expanded(
                          child: Text(
                            'Detalles para $nombreCultivo',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 10),
                    Text(
                      justificacion,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3B22).withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent, // Fondo transparente
                      radius: 25,
                      child: Image.asset(
                        iconoPath, // Toma la imagen dinámica
                        width: 40, // <-- AQUÍ le damos el tamaño exacto
                        height: 40, // <-- AQUÍ le damos el tamaño exacto
                        fit: BoxFit.contain, // <-- Evita el desbordamiento
                        // Si falla la ruta, muestra el icono verde como Plan B
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.eco_outlined,
                              color: Colors.greenAccent,
                              size: 30,
                            ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      nombreCultivo,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Motivo de recomendación:',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                // Texto truncado para no ocupar espacio (solo 2 líneas)
                Text(
                  justificacion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Botón: Ver Justificación
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.greenAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () => _mostrarDetalles(context),
                    child: const Text(
                      'Ver justificación',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Botón: Iniciar Seguimiento
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: estaGuardando ? null : alPresionarIniciar,
                    child: estaGuardando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Iniciar seguimiento',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
