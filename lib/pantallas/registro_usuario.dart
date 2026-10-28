import 'package:flutter/material.dart';
import 'iniciar_sesion.dart'; // Para poder regresar al login
import '../widgets/campo_texto.dart'; // <-- IMPORTANTE: Importamos tu nuevo widget reutilizable
import '../widgets/titulo_tul_luum.dart';

// MODIFICACIÓN 1: Cambiamos a StatefulWidget para poder usar la llave del formulario
class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  // ELEMENTO CLAVE PARA TU REPORTE: La llave global para validar el formulario
  final _llaveFormulario = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Imagen de fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/fondo_registro.png', // Asegúrate de tener esta imagen
              fit: BoxFit.cover,
            ),
          ),

          // 2. Contenido principal
          SafeArea(
            child: Center(
              // ELEMENTO CLAVE PARA TU REPORTE: SingleChildScrollView para evitar que el teclado oculte los botones
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    // Textos superiores
                    const Text(
                      'Tul lu umIoT',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const TituloTulLuum(
                      texto:
                          '!BIENVENIDO¡\ncrea tu cuenta para comenzar a\ncultivar un futuro mejor',
                      tamanoFuente: 28.0,
                    ),

                    // Tarjeta blanca central
                    // MODIFICACIÓN 2: Envolvemos la tarjeta blanca en un Form
                    Form(
                      key: _llaveFormulario, // Conectamos la llave aquí
                      child: Container(
                        padding: const EdgeInsets.all(25.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7F7).withOpacity(
                            0.95,
                          ), // Tono ligeramente crema/rosado como tu diseño
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Agregamos la función validadora a cada campo y se utiliza el widgets reutilizable
                            CampoTexto(
                              icono: Icons.person,
                              textoHint: 'nombre completo',
                              validador: (valor) {
                                if (valor == null || valor.trim().isEmpty) {
                                  return 'Por favor ingresa tu nombre'; // Esto sale en rojo
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),

                            CampoTexto(
                              icono: Icons.email,
                              textoHint: 'correo electronico',
                              validador: (valor) {
                                if (valor == null || valor.trim().isEmpty) {
                                  return 'Por favor ingresa tu correo';
                                }
                                if (!valor.contains('@')) {
                                  return 'Ingresa un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),

                            CampoTexto(
                              icono: Icons.lock,
                              textoHint: 'contraseña',
                              esPassword: true,
                              validador: (valor) {
                                if (valor == null || valor.trim().isEmpty) {
                                  return 'Por favor ingresa una contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),

                            CampoTexto(
                              icono: Icons.lock,
                              textoHint: 'confirmar contraseña',
                              esPassword: true,
                              validador: (valor) {
                                if (valor == null || valor.trim().isEmpty) {
                                  return 'Debes confirmar tu contraseña';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),

                            // Botón Registrar
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF43A047),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  // Lógica para registrar usuario
                                  // ELEMENTO CLAVE PARA TU REPORTE: Ejecutamos la validación
                                  if (_llaveFormulario.currentState!
                                      .validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('¡Registro Exitoso!'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'REGISTRAR',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Términos y condiciones
                            const Text(
                              'AL INGRESAR ACEPTAS NUESTROS\nTERMINOS Y CONDICIONES',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Enlace inferior para ir al login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿ya tienes cuenta? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IniciarSesion(),
                              ),
                            );
                          },
                          child: const Text(
                            'iniciar sesion',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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
