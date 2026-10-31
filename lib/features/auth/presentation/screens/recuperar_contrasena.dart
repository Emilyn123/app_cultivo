import 'package:flutter/material.dart';
import '../../../../core/widgets/campo_texto.dart'; // Ajusta la ruta según la carpeta donde tengas guardado tu widget
import '../../../../core/widgets/titulo_tul_luum.dart';

class RecuperarContrasenaScreen extends StatefulWidget {
  const RecuperarContrasenaScreen({super.key});

  @override
  State<RecuperarContrasenaScreen> createState() =>
      _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState extends State<RecuperarContrasenaScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Animación de entrada suave
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _enviarEnlace() {
    if (_formKey.currentState?.validate() ?? false) {
      final correo = _emailController.text.trim();

      // Aquí conectas tu servicio de recuperación (Firebase Auth o API REST)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Se ha enviado un enlace de recuperación a: $correo'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo.png', // O assets/images/fondo_registro.png según tu proyecto
              fit: BoxFit.cover,
            ),
          ),

          // 2. Botón para volver atrás
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.85),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),

          // 3. Contenedor principal responsivo y animado
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const TituloTulLuum(
                            texto: "RECUPERAR\nCONTRASEÑA",
                            tamanoFuente: 32.0,
                          ),

                          const SizedBox(height: 24),

                          // Tarjeta blanca con formulario
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 26.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(28.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Icon(
                                    Icons.lock_reset_rounded,
                                    size: 55,
                                    color: Color(0xFF2E7D32),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Ingresa el correo electrónico asociado a tu cuenta para restablecer tu contraseña.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(220, 0, 0, 0),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 22),

                                  // Campo de texto reutilizable
                                  CampoTexto(
                                    controller: _emailController,
                                    icono: Icons.mail,
                                    textoHint: 'correo electrónico',
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    validador: (valor) {
                                      if (valor == null ||
                                          valor.trim().isEmpty) {
                                        return 'Ingresa tu correo';
                                      }
                                      if (!valor.contains('@') ||
                                          !valor.contains('.')) {
                                        return 'Ingresa un correo válido';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 22),

                                  // Botón de Enviar Enlace
                                  ElevatedButton(
                                    onPressed: _enviarEnlace,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2E7D32),
                                      foregroundColor: Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14.0,
                                      ),
                                    ),
                                    child: const Text(
                                      'ENVIAR ENLACE',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Regresar al Login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '¿Ya Recordaste? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3.0,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Inicia sesión',
                                  style: TextStyle(
                                    color: Color(0xFF1E88E5),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3.0,
                                        color: Colors.black54,
                                      ),
                                    ],
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
          ),
        ],
      ),
    );
  }
}
