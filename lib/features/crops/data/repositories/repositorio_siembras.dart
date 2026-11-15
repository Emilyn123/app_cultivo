import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/database_service.dart';

class RepositorioSiembras {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Registra el cultivo aprobado enfocándose solo en la etapa de Siembra
  Future<void> registrarNuevaSiembra({
    required int idCultivo,
    required String nombreCultivo,
    required String nombreMuestra,
  }) async {
    try {
      final db = await DatabaseService.instance.database;

      // Guardado Local (Offline-First) enfocado en la Etapa 1 (Siembra)
      await db.insert('active_crops', {
        'id_cultivo': idCultivo,
        'crop_name': nombreCultivo,
        'nombre_muestra': nombreMuestra,
        'current_stage':
            1, // 1 = Etapa de Siembra (Única etapa activa por ahora)
        'started_at': DateTime.now().toIso8601String(),
      });

      // Intento de sincronización con Supabase
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        await _supabase.from('siembra_activa').insert({
          'id_usuario': userId,
          'id_cultivo': idCultivo,
          'fecha_plantacion': DateTime.now().toIso8601String(),
          'estado_seguimiento': 'Activo',
        });
      }
    } catch (e) {
      print(
        'Guardado local exitoso, pendiente de sincronización en la nube: $e',
      );
    }
  }
}
