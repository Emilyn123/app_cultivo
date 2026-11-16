import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/services/database_service.dart'; // <-- Base de datos local
import 'panel_general_etapas.dart';
import '../../../../core/widgets/menu_inferior.dart';
import '../../../home/presentation/screens/menu_principal.dart';
import '../../../profile/perfil_usuario.dart';
import '../../../crops/data/catalogo_cultivos.dart';

class MisCultivos extends StatelessWidget {
  const MisCultivos({super.key});

  // Función para obtener las siembras desde SQLite
  Future<List<Map<String, dynamic>>> _obtenerSiembrasActivas() async {
    final db = await DatabaseService.instance.database;
    return await db.query('active_crops', orderBy: 'started_at DESC');
  }

  @override
  Widget build(BuildContext context) {
    final Size tamanoPantalla = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: SizedBox(
        width: tamanoPantalla.width,
        height: tamanoPantalla.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Imagen de fondo
            Image.asset(
              RutasImagenes.fondoCampo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF131A15)),
            ),

            // 2. Capa oscura para contraste
            Container(color: Colors.black.withOpacity(0.25)),

            // 3. Contenido Principal con FutureBuilder
            SafeArea(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _obtenerSiembrasActivas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  final siembras = snapshot.data ?? [];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: constraints.maxWidth * 0.04,
                          right: constraints.maxWidth * 0.04,
                          top: 16.0,
                          bottom: 100.0,
                        ),
                        child: Column(
                          children: [
                            // Letrero de madera del diseño
                            Image.asset(
                              RutasImagenes.encabezadoSeguimiento,
                              width: (constraints.maxWidth * 0.6).clamp(
                                200.0,
                                300.0,
                              ),
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text(
                                    'Seguimiento de cultivo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 18.0),

                            if (siembras.isEmpty)
                              const _MensajeSinCultivos()
                            else
                              ...siembras.map(
                                (siembraDB) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // 1. Obtenemos el nombre exacto guardado en la base de datos local
                                      String nombreGuardado =
                                          siembraDB['crop_name'] ?? '';

                                      // 2. Buscamos en el catálogo global ignorando mayúsculas/minúsculas
                                      final cultivoEncontrado = CatalogoCultivos
                                          .todos
                                          .firstWhere(
                                            (c) =>
                                                c.nombre.toUpperCase() ==
                                                nombreGuardado.toUpperCase(),
                                            orElse: () => CatalogoCultivos
                                                .todos
                                                .first, // Respaldo por defecto
                                          );

                                      // Al tocar, navegamos al panel de etapas
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PanelGeneralEtapas(
                                            cultivo:
                                                cultivoEncontrado, //<-- Puedes pasarle el nombre aquí si lo necesitas
                                          ),
                                        ),
                                      );
                                    },
                                    child: _TarjetaSiembra(
                                      datosSiembra: siembraDB,
                                      anchoMaximo: constraints.maxWidth,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // 5. MENÚ INFERIOR CON LÓGICA DE NAVEGACIÓN
      bottomNavigationBar: MenuInferior(
        indiceSeleccionado: 1, // Estamos en "Mis Cultivos"
        alSeleccionar: (index) {
          if (index == 1) return;
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuPrincipal()),
            );
          }
          if (index == 2) {
            // Navegar a la pantalla de Alertas (cuando la crees)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text('Alertas')),
                  body: const Center(
                    child: Text(
                      'Pantalla en construcción 🚧',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            );
          }
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PerfilUsuario()),
            );
          }
        },
      ),
    );
  }
}

String _formatearFechaISO(String isoString) {
  try {
    final f = DateTime.parse(isoString);
    return '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}';
  } catch (e) {
    return '--/--/----';
  }
}

// Tarjeta dinámica de siembra conectada a SQLite
class _TarjetaSiembra extends StatelessWidget {
  final Map<String, dynamic> datosSiembra;
  final double anchoMaximo;

  const _TarjetaSiembra({
    required this.datosSiembra,
    required this.anchoMaximo,
  });

  @override
  Widget build(BuildContext context) {
    final double tamanoIcono = (anchoMaximo * 0.18).clamp(60.0, 85.0);

    // Extraemos los datos de la base de datos
    final String nombreCultivo = datosSiembra['crop_name'] ?? 'Desconocido';
    final String nombremuestra =
        datosSiembra['nombre_muestra'] ??
        'Sin nombre'; // <--- NUEVO: Leemos el lote
    final String fechaISO = datosSiembra['started_at'] ?? '';
    final int etapaActual = datosSiembra['current_stage'] ?? 1;

    final String infoFecha =
        'Siembra: ${_formatearFechaISO(fechaISO)} | Etapa Actual: $etapaActual';

    // 2. CORRECCIÓN DE IMAGEN: Buscamos el cultivo en tu catálogo
    final cultivoOficial = CatalogoCultivos.todos.firstWhere(
      (c) => c.nombre.toUpperCase() == nombreCultivo.toUpperCase(),
      orElse: () => CatalogoCultivos.todos.first,
    );

    // Determinamos qué icono usar en base al nombre
    final String rutaImagenOficial = RutasImagenes.iconoCultivo(
      cultivoOficial.carpetaImagenes,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: const Color(0xFF223521).withOpacity(0.92),
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
          Image.asset(
            rutaImagenOficial,
            width: tamanoIcono,
            height: tamanoIcono,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => SizedBox(
              width: tamanoIcono,
              height: tamanoIcono,
              child: Icon(
                Icons.eco_rounded,
                size: tamanoIcono * 0.6,
                color: Colors.white54,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  nombreCultivo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  minFontSize: 14.0,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                AutoSizeText(
                  'Lote: $nombremuestra', // <--- NUEVO: (Ej. Lote: Cuadrante Norte) Mostramos el terreno
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.greenAccent,
                  ),
                  maxLines: 1,
                  minFontSize: 11.0,
                ),
                const SizedBox(height: 8.0),
                AutoSizeText(
                  infoFecha,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  minFontSize: 9.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mensaje cuando el usuario todavía no tiene siembras (MANTENIDO EXACTAMENTE IGUAL)
class _MensajeSinCultivos extends StatelessWidget {
  const _MensajeSinCultivos();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF223521).withOpacity(0.92),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
      ),
      child: const Text(
        'Aún no tienes cultivos en seguimiento.\nInicia uno desde "Nuevo Cultivo".',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );
  }
}
