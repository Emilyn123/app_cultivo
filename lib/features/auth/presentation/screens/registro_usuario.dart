import 'package:flutter/material.dart';
import 'iniciar_sesion.dart'; // Para poder regresar al login
import '../controllers/auth_controller.dart';
//import '../../data/repositories/auth_repositorio.dart';
import '../../../home/presentation/screens/menu_principal.dart';
import '../../../../core/widgets/campo_texto.dart'; // Si usas el campo de texto
import '../../../../core/widgets/titulo_tul_luum.dart'; // Si usas el título animado

// MODIFICACIÓN 1: Cambiamos a StatefulWidget para poder usar la llave del formulario
class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  // ELEMENTO CLAVE PARA TU REPORTE: La llave global para validar el formulario
  final _llaveFormulario = GlobalKey<FormState>();

  // Controladores para capturar los datos ingresados
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthController _authController = AuthController();
  //final AuthRepositorio _authRepositorio = AuthRepositorio();

  @override
  void initState() {
    // suscribe los cambios para redibujar la pantalla
    super.initState();
    _authController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _authController.dispose();
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              // ELEMENTO CLAVE PARA TU REPORTE: SingleChildScrollView para evitar que el teclado oculte los botones
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 440,
                  ), // Ajuste responsivo
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
                            '!BIENVENIDO¡\nCrea tu cuenta para comenzar a\ncultivar un futuro mejor',
                        tamanoFuente: 28.0,
                      ),

                      const SizedBox(height: 15),

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
                                controller: _nombreController,
                                icono: Icons.person,
                                textoHint: 'nombre completo',
                                textInputAction: TextInputAction.next,
                                validador: (valor) {
                                  if (valor == null || valor.trim().isEmpty) {
                                    return 'Por favor ingresa tu nombre'; // Esto sale en rojo
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              CampoTexto(
                                controller: _correoController,
                                icono: Icons.email,
                                textoHint: 'correo electrónico',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validador: (valor) {
                                  if (valor == null || valor.trim().isEmpty) {
                                    return 'Por favor ingresa tu correo';
                                  }
                                  if (!valor.contains('@') ||
                                      !valor.contains('.')) {
                                    return 'Ingresa un correo válido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              CampoTexto(
                                controller: _passwordController,
                                icono: Icons.lock,
                                textoHint: 'contraseña',
                                esPassword: true,
                                textInputAction: TextInputAction.next,
                                validador: (valor) {
                                  if (valor == null || valor.trim().isEmpty) {
                                    return 'Por favor ingresa una contraseña';
                                  }
                                  if (valor.length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),

                              CampoTexto(
                                controller: _confirmPasswordController,
                                icono: Icons.lock,
                                textoHint: 'confirmar contraseña',
                                esPassword: true,
                                textInputAction: TextInputAction.done,
                                validador: (valor) {
                                  if (valor == null || valor.trim().isEmpty) {
                                    return 'Debes confirmar tu contraseña';
                                  }
                                  if (valor != _passwordController.text) {
                                    return 'Las contraseñas no coinciden';
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
                                  //funcion del boton
                                  onPressed: _authController.cargando
                                      ? null
                                      : () async {
                                          // 1. Validar que los campos cumplan las condiciones
                                          if (_llaveFormulario.currentState!
                                              .validate()) {
                                            // 2. Usar la variable _authRepositorio para guardar en Supabase
                                            final exito = await _authController
                                                .registrar(
                                                  nombreCompleto:
                                                      _nombreController.text,
                                                  correo:
                                                      _correoController.text,
                                                  password:
                                                      _passwordController.text,
                                                );

                                            print(
                                              "--> [UI] ¿Registro exitoso?: $exito",
                                            );

                                            if (!mounted) return;

                                            // 3. Evaluar la respuesta
                                            if (exito) {
                                              print(
                                                "--> [UI] Redirigiendo a MenuPrincipal...",
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    '¡Usuario registrado con éxito!',
                                                  ),
                                                ),
                                              );

                                              // Redirigir al Menú Principal
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MenuPrincipal(),
                                                ),
                                              );
                                            } else {
                                              print(
                                                "--> [UI] Fallo de registro: ${_authController.mensajeError}",
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _authController
                                                            .mensajeError ??
                                                        'Error desconocido',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },

                                  child: _authController.cargando
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
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
                            '¿Ya tienes cuenta? ',
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
                              'Iniciar sesion',
                              style: TextStyle(
                                color: Color.fromARGB(255, 251, 3, 3),
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
        ],
      ),
    );
  }
}
