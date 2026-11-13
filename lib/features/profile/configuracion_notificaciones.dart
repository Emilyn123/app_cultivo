import 'package:flutter/material.dart';
import '../../core/widgets/tarjeta_cristal.dart'; // Ajusta la ruta

class ConfiguracionNotificaciones extends StatefulWidget {
  const ConfiguracionNotificaciones({super.key});

  @override
  State<ConfiguracionNotificaciones> createState() =>
      _ConfiguracionNotificacionesState();
}

class _ConfiguracionNotificacionesState
    extends State<ConfiguracionNotificaciones> {
  bool _alertasRiego = true;
  bool _alertasNutrientes = true;
  bool _alertasClima = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withAlpha(120)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TarjetaCristal(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Alertas de Riego',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Notificar cuando la humedad sea baja',
                        style: TextStyle(color: Colors.white70),
                      ),
                      activeColor: Colors.greenAccent,
                      value: _alertasRiego,
                      onChanged: (bool value) =>
                          setState(() => _alertasRiego = value),
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Alertas de Nutrientes (PH/CE)',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Desajustes en la calidad del suelo',
                        style: TextStyle(color: Colors.white70),
                      ),
                      activeColor: Colors.greenAccent,
                      value: _alertasNutrientes,
                      onChanged: (bool value) =>
                          setState(() => _alertasNutrientes = value),
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Alertas de Temperatura',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Notificar si hace demasiado calor/frío',
                        style: TextStyle(color: Colors.white70),
                      ),
                      activeColor: Colors.greenAccent,
                      value: _alertasClima,
                      onChanged: (bool value) =>
                          setState(() => _alertasClima = value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
