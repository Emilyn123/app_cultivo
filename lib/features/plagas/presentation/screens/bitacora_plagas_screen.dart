// lib/features/plagas/presentation/screens/bitacora_plagas_screen.dart

import 'package:flutter/material.dart';
import '../../domain/plaga.dart';
import '../../../../core/widgets/encabezado_personalizado.dart';

class BitacoraPlagasScreen extends StatefulWidget {
  const BitacoraPlagasScreen({super.key});

  @override
  State<BitacoraPlagasScreen> createState() => _BitacoraPlagasScreenState();
}

class _BitacoraPlagasScreenState extends State<BitacoraPlagasScreen> {
  String _textoBusqueda = '';

  List<Plaga> get _plagasFiltradas {
    if (_textoBusqueda.trim().isEmpty) return listaPlagas;
    final consulta = _textoBusqueda.toLowerCase();
    return listaPlagas.where((p) {
      return p.nombre.toLowerCase().contains(consulta) ||
          p.causa.toLowerCase().contains(consulta);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final plagas = _plagasFiltradas;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1E12),
      body: Stack(
        children: [
          // Fondo agrícola consistente con el resto de la app
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/seguimiento/campo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFF0F1E12)),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.55)),

          SafeArea(
            child: Column(
              children: [
                // Encabezado estándar de la app
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: 10,
                  ),
                  child: const EncabezadoPersonalizado(
                    titulo: 'Diccionario de Plagas',
                  ),
                ),

                // Barra de búsqueda rápida
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: 6,
                  ),
                  child: TextField(
                    onChanged: (valor) =>
                        setState(() => _textoBusqueda = valor),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar plaga o condición (ej. humedad)...',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.greenAccent,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1B2E1D).withOpacity(0.9),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Lista desplegable de plagas
                Expanded(
                  child: plagas.isEmpty
                      ? const Center(
                          child: Text(
                            'No se encontraron plagas con ese criterio.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                            vertical: 8,
                          ),
                          itemCount: plagas.length,
                          itemBuilder: (context, index) {
                            final plaga = plagas[index];
                            return _TarjetaPlaga(plaga: plaga);
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

class _TarjetaPlaga extends StatelessWidget {
  final Plaga plaga;

  const _TarjetaPlaga({required this.plaga});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF223521).withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.greenAccent,
          collapsedIconColor: Colors.white70,
          tilePadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.035,
            vertical: 6,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              plaga.rutaImagen,
              width: size.width * 0.13,
              height: size.width * 0.13,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: size.width * 0.13,
                height: size.width * 0.13,
                color: Colors.white12,
                child: const Icon(Icons.bug_report, color: Colors.greenAccent),
              ),
            ),
          ),
          title: Text(
            plaga.nombre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            plaga.causa,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.04,
                4,
                size.width * 0.04,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      plaga.rutaImagen,
                      height: size.height * 0.22,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: size.height * 0.22,
                        color: Colors.white10,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        color: Colors.greenAccent,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Descripción física:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plaga.descripcionFisica,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.amberAccent,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Causa / Condiciones:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plaga.causa,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
