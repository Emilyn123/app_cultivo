import 'package:flutter/material.dart';
import '../../core/widgets/tarjeta_cristal.dart'; // Ajusta la ruta a tu widget
import '../../core/widgets/campo_texto.dart'; // Ajusta la ruta a tu widget
import '../auth/presentation/controllers/auth_controller.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  // 1. Llave para validar los campos y el Controlador
  final _llaveFormulario = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  // 2. Controladores para capturar el texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Escucha los cambios del controlador (ej. cuando "cargando" cambia a true/false)
    _authController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _authController.dispose();
    _nombreController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          'Editar Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fondo
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/fondo.png', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withAlpha(120)),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: 20,
              ),
              child: TarjetaCristal(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  // Envolvemos los campos en el Form
                  child: Form(
                    key: _llaveFormulario,
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // CAMPO: NUEVO NOMBRE
                        CampoTexto(
                          icono: Icons.person,
                          textoHint: 'Nuevo Nombre Completo',
                          controller: _nombreController,
                        ),
                        const SizedBox(height: 20),

                        // CAMPO: NUEVA CONTRASEÑA
                        CampoTexto(
                          icono: Icons.lock,
                          textoHint: 'Nueva Contraseña (Opcional)',
                          esPassword: true,
                          controller: _passwordController,
                          validador: (valor) {
                            if (valor != null &&
                                valor.isNotEmpty &&
                                valor.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null; // Es válido o está vacío (opcional)
                          },
                        ),
                        const SizedBox(height: 40),

                        // BOTÓN DE GUARDAR
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF388E3C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: _authController.cargando
                                ? null
                                : () async {
                                    // 1. Validar el formulario
                                    if (_llaveFormulario.currentState!
                                        .validate()) {
                                      // 2. Verificar que al menos un campo tenga datos
                                      if (_nombreController.text
                                              .trim()
                                              .isEmpty &&
                                          _passwordController.text
                                              .trim()
                                              .isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Escribe un nuevo nombre o contraseña para actualizar.',
                                            ),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      // 3. Ejecutar la actualización en el Backend
                                      final exito = await _authController
                                          .actualizarPerfilYPassword(
                                            nuevoNombre: _nombreController.text
                                                .trim(),
                                            nuevaPassword: _passwordController
                                                .text
                                                .trim(),
                                          );

                                      if (!context.mounted) return;

                                      if (exito) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Perfil actualizado exitosamente',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pop(
                                          context,
                                        ); // Regresa a la pantalla principal del perfil
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              _authController.mensajeError ??
                                                  'Error al actualizar',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: _authController.cargando
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'GUARDAR CAMBIOS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
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
