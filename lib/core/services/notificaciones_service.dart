import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/alertas/domain/alertas_service.dart';

class NotificacionesService {
  static final NotificacionesService instance = NotificacionesService._init();
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificacionesService._init();

  Future<void> inicializar() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Merida'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(settings);

    // Pedir permiso en Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Programa automáticamente las 4 notificaciones de cambio de etapa al crear una siembra
  Future<void> programarRecordatoriosSiembra({
    required int idBase,
    required String nombreCultivo,
    required DateTime fechaSiembra,
  }) async {
    final diasEtapas = AlertasService.diasPorEtapa(nombreCultivo);
    const nombres = AlertasService.nombresEtapas;

    // Etapas 2 a 5 (índices 1..4)
    for (int i = 1; i < diasEtapas.length; i++) {
      final fechaAviso = DateTime(
        fechaSiembra.year,
        fechaSiembra.month,
        fechaSiembra.day + diasEtapas[i],
        8, // 8:00 AM
        0,
      );

      if (fechaAviso.isBefore(DateTime.now())) continue;

      await _plugin.zonedSchedule(
        idBase * 10 + i, // ID único por siembra y etapa
        'Nueva etapa en $nombreCultivo',
        'Tu cultivo entra a etapa de ${nombres[i]}. Revisa el pH, CE, temperatura y humedad de la tierra.',
        tz.TZDateTime.from(fechaAviso, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'canal_etapas',
            'Recordatorios de Etapas',
            channelDescription: 'Avisos cuando un cultivo cambia de etapa',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  /// Para probar de inmediato que la notificación suena en tu celular
  Future<void> mostrarNotificacionPrueba() async {
    await _plugin.show(
      9999,
      'Tul lu\'um IoT',
      'Recordatorio de prueba: revisa los parámetros de tu suelo.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_etapas',
          'Recordatorios de Etapas',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
