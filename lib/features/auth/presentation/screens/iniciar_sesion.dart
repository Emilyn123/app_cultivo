import 'package:flutter/material.dart';
import '../../../../core/widgets/campo_texto.dart'; // Si usas el campo de texto
import '../../../../core/widgets/titulo_tul_luum.dart'; // Si usas el título animado
import '../../../home/presentation/screens/menu_principal.dart'; //dashboard
import 'registro_usuario.dart'; //registro si no tiene cuenta
import 'recuperar_contrasena.dart'; // Import de la pantalla de recuperación

// MODIFICACIÓN 1: Cambiamos a StatefulWidget para poder usar la llave del formulario
class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  // ELEMENTO CLAVE: La llave global para validar el formulario de inicio de sesión
  final _llaveFormulario = GlobalKey<FormState>();

  // Controladores de texto para capturar los datos ingresados
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                // MODIFICACIÓN 2: Envolvemos los campos en un Form conectado a la llave
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 420,
                  ), // Ajuste responsivo para tablets/pantallas anchas
                  child: Form(
                    key: _llaveFormulario,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo superior
                        Image.asset(
                          'assets/images/logo_superior.png',
                          height: 80,
                        ),
                        const SizedBox(height: 20),

                        // Texto de Bienvenida
                        const TituloTulLuum(texto: "BIENVENIDO"),

                        // Espacio para dejar ver la ilustración del centro del fondo
                        const SizedBox(height: 150),

                        // MODIFICACIÓN 3: Usamos tu widget reutilizable "CampoTexto" y le pasamos el validador
                        // Campo de Usuario
                        CampoTexto(
                          controller: _usuarioController,
                          icono: Icons.person,
                          textoHint: 'Usuario',
                          validador: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Por favor ingresa tu usuario'; // Error en rojo
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Campo de Contraseña
                        CampoTexto(
                          controller: _passwordController,
                          icono: Icons.lock,
                          textoHint: 'contraseña',
                          esPassword: true,
                          validador: (valor) {
                            if (valor == null || valor.trim().isEmpty) {
                              return 'Por favor ingresa tu contraseña'; // Error en rojo
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Botón de Ingreso
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF2E7D32,
                              ), // Verde oscuro
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // Validamos que los campos no estén vacíos
                              if (_llaveFormulario.currentState!.validate()) {
                                // --- AQUÍ ESTÁ LA CONEXIÓN DE LA NAVEGACIÓN ---
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MenuPrincipal(),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'INGRESAR',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Texto "olvidé mi contraseña" con navegación hacia recuperar_contrasena
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RecuperarContrasenaScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'olvide mi contraseña',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '¿No tienes cuenta? ',
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
                                    builder: (context) =>
                                        const RegistroUsuario(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Registrate',
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
            ),
          ),
        ],
      ),
    );
  }
}
