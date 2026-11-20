// lib/features/reports/data/reporte_pdf_service.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/database_service.dart';
import '../../fertilizacion/domain/fertilizacion.dart';

class ReportePdfService {
  /// Genera y abre la vista previa/compartir del Reporte General de la Finca
  static Future<void> generarYMostrarReporteGeneral() async {
    final pdfBytes = await _construirDocumentoPdf();

    await Printing.layoutPdf(
      name: 'Reporte_Tul_Luum_${DateTime.now().millisecondsSinceEpoch}.pdf',
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  static Future<Uint8List> _construirDocumentoPdf() async {
    final pdf = pw.Document();
    final db = await DatabaseService.instance.database;

    // 1. Obtener datos del agricultor desde SQLite
    final sesion = await db.query('sesion_activa', limit: 1);
    final String nombreAgricultor = sesion.isNotEmpty
        ? (sesion.first['nombre']?.toString() ?? 'Agricultor Tul lu\'um')
        : 'Agricultor Tul lu\'um';
    final String correoAgricultor = sesion.isNotEmpty
        ? (sesion.first['correo']?.toString() ?? 'Sin correo registrado')
        : 'Modo Local Offline';

    // 2. Obtener cultivos activos
    final siembras = await db.query('active_crops', orderBy: 'started_at DESC');

    // 3. Obtener últimas lecturas manuales de suelo
    final lecturas = await db.query(
      'registros_manuales_pendientes',
      orderBy: 'fecha_registro DESC',
      limit: 15,
    );

    // 4. Obtener historial de fertilización foliar desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? fertRaw = prefs.getString('fertilizacion_historial');
    List<Fertilizacion> fertilizaciones = [];
    if (fertRaw != null) {
      final List<dynamic> decoded = jsonDecode(fertRaw);
      fertilizaciones = decoded
          .map((item) => Fertilizacion.fromJson(item))
          .toList();
    }

    final ahora = DateTime.now();
    final fechaGeneracion =
        '${ahora.day.toString().padLeft(2, '0')}/${ahora.month.toString().padLeft(2, '0')}/${ahora.year} ${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}';

    // Paleta institucional verde agrícola
    final colorVerdeOscuro = PdfColor.fromHex('#1B3B22');
    final colorVerdeMedio = PdfColor.fromHex('#2E7D32');
    final colorFondoSuave = PdfColor.fromHex('#F1F8E9');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 12),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: colorVerdeMedio, width: 2),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "TUL LU'UM IoT",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: colorVerdeOscuro,
                    ),
                  ),
                  pw.Text(
                    'Reporte Técnico de Monitoreo Agrícola y Suelo',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Fecha de emisión:',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: colorVerdeOscuro,
                    ),
                  ),
                  pw.Text(
                    fechaGeneracion,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount} • Generado por Tul lu\'um IoT',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 14),

          // --- SECCIÓN 1: DATOS DEL PRODUCTOR ---
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: colorFondoSuave,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: colorVerdeMedio, width: 0.8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Productor: $nombreAgricultor',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        color: colorVerdeOscuro,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Cuenta: $correoAgricultor',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Cultivos Activos: ${siembras.length}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        color: colorVerdeOscuro,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Análisis de Suelo: ${lecturas.length}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 18),

          // --- SECCIÓN 2: CULTIVOS EN SEGUIMIENTO ---
          _tituloSeccion('1. Parcelas y Cultivos Activos', colorVerdeOscuro),
          pw.SizedBox(height: 6),
          if (siembras.isEmpty)
            pw.Text(
              'No hay cultivos activos registrados en el sistema.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            )
          else
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              headerDecoration: pw.BoxDecoration(color: colorVerdeOscuro),
              cellStyle: const pw.TextStyle(fontSize: 9.5),
              cellPadding: const pw.EdgeInsets.all(6),
              headers: [
                'Cultivo',
                'Lote / Cuadrante',
                'Etapa Actual',
                'Fecha Siembra',
              ],
              data: siembras.map((s) {
                return [
                  (s['crop_name'] ?? 'N/A').toString(),
                  (s['nombre_muestra'] ?? s['nombre_lote'] ?? 'Sin lote')
                      .toString(),
                  'Etapa ${s['current_stage'] ?? 1}',
                  _formatearFecha((s['started_at'] ?? '').toString()),
                ];
              }).toList(),
            ),

          pw.SizedBox(height: 18),

          // --- SECCIÓN 3: HISTORIAL DE PARÁMETROS DEL SUELO ---
          _tituloSeccion(
            '2. Últimas Lecturas Fisicoquímicas del Suelo',
            colorVerdeOscuro,
          ),
          pw.SizedBox(height: 6),
          if (lecturas.isEmpty)
            pw.Text(
              'No se han capturado mediciones de suelo todavía.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            )
          else
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 9.5,
              ),
              headerDecoration: pw.BoxDecoration(color: colorVerdeMedio),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellPadding: const pw.EdgeInsets.all(5),
              headers: [
                'Fecha',
                'Lote',
                'pH',
                'CE (dS/m)',
                'Temp (°C)',
                'Humedad (%)',
              ],
              data: lecturas.map((l) {
                return [
                  _formatearFecha((l['fecha_registro'] ?? '').toString()),
                  (l['nombre_muestra'] ?? 'N/A').toString(),
                  (l['ph_medido'] ?? '-').toString(),
                  (l['ce_medida'] ?? '-').toString(),
                  (l['temp_medida'] ?? '-').toString(),
                  '${l['humedad_medida'] ?? '-'}%',
                ];
              }).toList(),
            ),

          pw.SizedBox(height: 18),

          // --- SECCIÓN 4: BITÁCORA DE FERTILIZACIÓN FOLIAR ---
          _tituloSeccion(
            '3. Bitácora de Fertilización Foliar',
            colorVerdeOscuro,
          ),
          pw.SizedBox(height: 6),
          if (fertilizaciones.isEmpty)
            pw.Text(
              'No hay aplicaciones de fertilización foliar registradas.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            )
          else
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 9.5,
              ),
              headerDecoration: pw.BoxDecoration(color: colorVerdeOscuro),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellPadding: const pw.EdgeInsets.all(5),
              headers: ['Fecha', 'Producto', 'Dosis', 'Cultivo y Notas'],
              data: fertilizaciones.map((f) {
                final fecha =
                    '${f.fechaHora.day.toString().padLeft(2, '0')}/${f.fechaHora.month.toString().padLeft(2, '0')}/${f.fechaHora.year}';
                return [
                  fecha,
                  f.producto,
                  '${f.cantidad} ${f.unidad}',
                  f.notas ?? 'Sin observaciones',
                ];
              }).toList(),
            ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _tituloSeccion(String texto, PdfColor color) {
    return pw.Text(
      texto,
      style: pw.TextStyle(
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );
  }

  static String _formatearFecha(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '--/--/----';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
