// lib/features/reports/presentation/screens/exportar_reporte_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/rutas_imagenes.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../data/reporte_pdf_service.dart';

class ExportarReporteScreen extends StatefulWidget {
  const ExportarReporteScreen({super.key});

  @override
  State<ExportarReporteScreen> createState() => _ExportarReporteScreenState();
}

class _ExportarReporteScreenState extends State<ExportarReporteScreen> {
  bool _generando = false;

  Future<void> _exportarPdf() async {
    setState(() => _generando = true);
    try {
      await ReportePdfService.generarYMostrarReporteGeneral();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar el PDF: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _generando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1E12),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            RutasImagenes.fondoCampo,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF0F1E12)),
          ),
          Container(color: Colors.black.withOpacity(0.50)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: 12.0,
                  ),
                  child: const EncabezadoPersonalizado(titulo: 'Reportes PDF'),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                        vertical: 16,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF223521).withOpacity(0.90),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.greenAccent.withOpacity(0.35),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.picture_as_pdf_rounded,
                                    color: Colors.greenAccent,
                                    size: 54,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Reporte Integral de Finca',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Genera un documento PDF listo para compartir o imprimir con el resumen completo de tus parcelas activas, mediciones de pH/CE/Humedad y bitácora de fertilización foliar.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13.5,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed: _generando ? null : _exportarPdf,
                                    icon: _generando
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.download_rounded,
                                            color: Colors.white,
                                          ),
                                    label: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _generando
                                            ? 'Generando documento...'
                                            : 'Generar y Compartir PDF',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF388E3C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
