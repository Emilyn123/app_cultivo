import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../../core/widgets/tarjeta_cultivo_elegir.dart';
// Importamos la nueva pantalla de ingreso manual en lugar de la de comparación
import '../../../monitor/presentation/screens/captura_manual.dart';

class SeleccionCultivo extends StatefulWidget {
  const SeleccionCultivo({super.key});

  @override
  State<SeleccionCultivo> createState() => _SeleccionCultivoState();
}

class _SeleccionCultivoState extends State<SeleccionCultivo> {
  //final SupabaseClient _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _cultivosFuture;

  @override
  void initState() {
    super.initState();
    _cultivosFuture = _obtenerCultivos();
  }

  // Lógica Offline-First: Intenta leer de la nube, si falla usa el caché local
  Future<List<Map<String, dynamic>>> _obtenerCultivos() async {
    try {
      // Futura consulta a tu tabla dim_cultivo cruzada con dim_parametros_optimos
      // final response = await _supabase.from('dim_cultivo').select('*, dim_parametros_optimos(*)');
      // return response;

      // Forzamos el error temporalmente para usar el catálogo local hasta que llenes Supabase
      throw Exception('Usando caché local');
    } catch (e) {
      // Catálogo local (Offline) para asegurar que el usuario siempre vea opciones
      return [
        {
          'id_cultivo': 1,
          'nombre': 'TOMATE ROJO',
          'imagenPath': 'assets/images/tomate_rojo.png',
          'ph': '5.8 - 6.8',
          'ce': '2.0 a 2.2 mS/cm',
          'temp': '20 y 30°C',
          'hum': '60% - 80%',
        },
        {
          'id_cultivo': 2,
          'nombre': 'FRIJOL',
          'imagenPath': 'assets/images/frijol.png',
          'ph': '6.5 y 7.5',
          'ce': 'Menor a 1.0 dS/m',
          'temp': '19-25°C',
          'hum': '12% a 13%',
        },
        {
          'id_cultivo': 3,
          'nombre': 'CILANTRO',
          'imagenPath': 'assets/images/cilantro.png',
          'ph': '6.2-7.5',
          'ce': '1.5 y 3 mS',
          'temp': '15 y 20 °C',
          'hum': '75%',
        },
        {
          'id_cultivo': 4,
          'nombre': 'RABANO',
          'imagenPath': 'assets/images/rabano.png',
          'ph': '6.0 - 7.0',
          'ce': '1.2 a 1.5 mS/cm',
          'temp': '18 °C y 22 °C',
          'hum': '60% y 80%',
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingLateral = (size.width * 0.05).clamp(14.0, 24.0);
    final espaciadoColumnas = (size.width * 0.04).clamp(12.0, 18.0);
    final separacionFilas = (size.height * 0.045).clamp(28.0, 44.0);
    final int columnas = size.width > 900 ? 4 : (size.width > 600 ? 3 : 2);
    final double proporcionAspecto = size.width > 600 ? 0.65 : 0.54;

    return Scaffold(
      backgroundColor: const Color(0xFF131E17),
      body: SafeArea(
        child: Column(
          children: [
            const EncabezadoPersonalizado(titulo: 'Selecciona tu cultivo'),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _cultivosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay cultivos disponibles',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final cultivos = snapshot.data!;

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingLateral,
                      vertical: 30.0,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      crossAxisSpacing: espaciadoColumnas,
                      mainAxisSpacing: separacionFilas,
                      childAspectRatio: proporcionAspecto,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: cultivos.length,
                    itemBuilder: (context, index) {
                      final cultivo = cultivos[index];
                      return TarjetaCultivoElegir(
                        imagenPath: cultivo['imagenPath'],
                        nombre: cultivo['nombre'],
                        ph: cultivo['ph'],
                        ce: cultivo['ce'],
                        temp: cultivo['temp'],
                        hum: cultivo['hum'],
                        alPresionar: () {
                          // Navega al formulario manual pasando el ID del cultivo
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CapturaManualSuelo(
                                // Se requerirá que tu CapturaManualSuelo acepte este parámetro
                                // idCultivoEsperado: cultivo['id_cultivo'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
