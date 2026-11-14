import 'package:flutter/material.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';
import '../../../../core/widgets/tarjeta_cultivo_elegir.dart';
// Importamos el cerebro matemático para extraer el catálogo unificado
import '../../../monitor/domain/servicio_diagnostico.dart';
// Importamos la pantalla que sigue en tu flujo
import '../../../monitor/presentation/screens/registro_lote.dart';

class SeleccionCultivo extends StatefulWidget {
  const SeleccionCultivo({super.key});

  @override
  State<SeleccionCultivo> createState() => _SeleccionCultivoState();
}

class _SeleccionCultivoState extends State<SeleccionCultivo> {
  late Future<List<Map<String, dynamic>>> _cultivosFuture;

  @override
  void initState() {
    super.initState();
    _cultivosFuture = _obtenerCultivos();
  }

  // Extrae el catálogo directamente desde la lógica central (servicio_diagnostico.dart)
  Future<List<Map<String, dynamic>>> _obtenerCultivos() async {
    try {
      // Aquí irá la futura consulta a Supabase
      throw Exception('Usando catálogo centralizado offline');
    } catch (e) {
      // Regresa el catálogo extraído de tu investigación
      return ServicioDiagnostico.obtenerCatalogoCultivos();
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
              child: FutureBuilder<List>(
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
                          // Navegación al paso de registro de lote llevando el ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistroLoteScreen(
                                idCultivoEsperado: cultivo['id_cultivo'],
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
