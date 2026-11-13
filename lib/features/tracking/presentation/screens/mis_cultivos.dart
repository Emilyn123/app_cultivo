import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../data/datos_locales_siembras.dart';
import '../../domain/siembra.dart';
import 'panel_general_etapas.dart';
import '../../../../core/widgets/menu_inferior.dart';
import '../../../home/presentation/screens/menu_principal.dart';
import '../../../profile/perfil_usuario.dart';

/// Lista de cultivos que el usuario está sembrando.
/// Al tocar uno, abre la guía de seguimiento de ese cultivo.
class MisCultivos extends StatelessWidget {
  const MisCultivos({super.key});

  @override
  Widget build(BuildContext context) {
    // Pendiente: más adelante vendrá de Supabase (FutureBuilder).
    final List<Siembra> siembras = DatosLocalesSiembras.siembras;

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

            // 3. Contenido
            SafeArea(
              child: LayoutBuilder(
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
                            (siembra) => Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PanelGeneralEtapas(
                                        cultivo: siembra.cultivo,
                                      ),
                                    ),
                                  );
                                },
                                child: _TarjetaSiembra(
                                  siembra: siembra,
                                  anchoMaximo: constraints.maxWidth,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 4. Botón flotante de regreso
            const _BotonRegreso(),
          ],
        ),
      ),
      // 3. MENÚ INFERIOR CON LÓGICA DE NAVEGACIÓN
      bottomNavigationBar: MenuInferior(
        indiceSeleccionado: 1, // Estamos en "Mis Cultivos"
        alSeleccionar: (index) {
          if (index == 1) return; // Si toca el mismo ícono, no hace nada

          if (index == 0) {
            // Regresa a la pestaña Inicio
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuPrincipal()),
            );
          }
          if (index == 3) {
            // Regresa a la pestaña Inicio
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

String _formatearFecha(DateTime f) =>
    '${f.day.toString().padLeft(2, '0')}/'
    '${f.month.toString().padLeft(2, '0')}/${f.year}';

// Tarjeta de una siembra
class _TarjetaSiembra extends StatelessWidget {
  final Siembra siembra;
  final double anchoMaximo;

  const _TarjetaSiembra({required this.siembra, required this.anchoMaximo});

  @override
  Widget build(BuildContext context) {
    final double tamanoIcono = (anchoMaximo * 0.18).clamp(60.0, 85.0);
    final String infoFecha =
        'Siembra: ${_formatearFecha(siembra.fechaSiembra)} | '
        'Etapa Actual: ${siembra.etapaActual().nombre}';

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
          // Icono del cultivo. Si aún no existe la imagen, muestra uno genérico.
          Image.asset(
            RutasImagenes.iconoCultivo(siembra.cultivo.carpetaImagenes),
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
                  siembra.nombre,
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
                const SizedBox(height: 8.0),
                AutoSizeText(
                  siembra.descripcion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 2,
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

// Mensaje cuando el usuario todavía no tiene siembras
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
        'Aún no tienes cultivos en seguimiento.\n'
        'Inicia uno desde "Nuevo Cultivo".',
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

// Botón flotante de regreso (translúcido, igual al de la pantalla de detalle)
class _BotonRegreso extends StatelessWidget {
  const _BotonRegreso();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
