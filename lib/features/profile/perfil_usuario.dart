import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'editar_perfil.dart'; // Importa la nueva pantalla
import 'configuracion_notificaciones.dart'; // Importa la nueva pantalla
import '../../core/widgets/menu_inferior.dart';
import '../home/presentation/screens/menu_principal.dart';
import '../tracking/presentation/screens/mis_cultivos.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  int _indiceSeleccionado = 3;

  // --
  // --- 1. INSERTA ESTA VARIABLE Y FUNCIÓN AQUÍ ---
  File? _imagenPerfil;

  Future<void> _cambiarFoto() async {
    final picker = ImagePicker();
    // Abre la galería (puedes usar ImageSource.camera para la cámara)
    final XFile? imagenSeleccionada = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagenSeleccionada != null) {
      setState(() {
        _imagenPerfil = File(imagenSeleccionada.path);
      });
    }
  }
  // ----------------------------------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 1. Imagen de fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black.withAlpha(100),
          ), // Filtro oscuro usando withAlpha
          // 2. Contenido Principal
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                top: size.height * 0.04,
                bottom: 100.0,
              ),
              child: Column(
                children: [
                  // --- ENCABEZADO DEL PERFIL ---
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: size.width * 0.15,
                              backgroundColor: Colors.white24,
                              backgroundImage: _imagenPerfil != null
                                  ? FileImage(_imagenPerfil!)
                                  : null,
                              child: _imagenPerfil == null
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: size.width * 0.15,
                                    )
                                  : null,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF388E3C),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: _cambiarFoto,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'Hola, Agricultor',
                          style: TextStyle(
                            fontSize: size.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'agricultor@gmail.com',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // --- ESTADÍSTICAS RÁPIDAS ---
                  _TarjetaEstadisticasCristal(size: size),
                  SizedBox(height: size.height * 0.04),

                  // --- LISTA DE OPCIONES ---
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Configuraciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  _OpcionPerfilCristal(
                    icono: Icons.manage_accounts_outlined,
                    titulo: 'Editar Perfil',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditarPerfil(),
                        ),
                      );
                    },
                  ),
                  _OpcionPerfilCristal(
                    icono: Icons.notifications_active_outlined,
                    titulo: 'Notificaciones y Alertas',
                    alPresionar: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ConfiguracionNotificaciones(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.04),

                  // --- BOTÓN CERRAR SESIÓN ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.redAccent,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: Colors.redAccent.withAlpha(25),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        // Lógica de logout y retorno a login
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- MENÚ INFERIOR ---
      bottomNavigationBar: MenuInferior(
        indiceSeleccionado: 3, // El índice 3 es el Perfil
        alSeleccionar: (index) {
          if (index == 3) return; // Si ya estás en Perfil, no hace nada

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuPrincipal()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MisCultivos()),
            );
          }
          // Agrega el index 2 para Alertas cuando tengas esa pantalla
        },
      ),
    );
  }
}

// Widgets internos
class _TarjetaEstadisticasCristal extends StatelessWidget {
  final Size size;
  const _TarjetaEstadisticasCristal({required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B3B22).withAlpha(165),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(75), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _Estadistica(valor: '4', etiqueta: 'Cultivos\nActivos'),
              Container(height: 40, width: 1, color: Colors.white30),
              const _Estadistica(valor: '12', etiqueta: 'Alertas\nResueltas'),
              Container(height: 40, width: 1, color: Colors.white30),
              const _Estadistica(valor: '45', etiqueta: 'Días\nen la app'),
            ],
          ),
        ),
      ),
    );
  }
}

class _Estadistica extends StatelessWidget {
  final String valor;
  final String etiqueta;
  const _Estadistica({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          etiqueta,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

class _OpcionPerfilCristal extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final VoidCallback alPresionar;

  const _OpcionPerfilCristal({
    required this.icono,
    required this.titulo,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: ListTile(
            onTap: alPresionar,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.white.withAlpha(50), width: 1),
            ),
            tileColor: Colors.white.withAlpha(25),
            leading: Icon(icono, color: Colors.greenAccent, size: 28),
            title: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
