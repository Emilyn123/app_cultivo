import 'package:flutter/material.dart';
import '../../core/widgets/tarjeta_cristal.dart'; // Ajusta la ruta a tu widget
import '../../core/widgets/campo_texto.dart'; // Ajusta la ruta a tu widget

class EditarPerfil extends StatelessWidget {
  const EditarPerfil({super.key});

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
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const CampoTexto(
                        icono: Icons.person,
                        textoHint: 'Nombre Completo',
                      ),
                      const SizedBox(height: 20),
                      const CampoTexto(
                        icono: Icons.email,
                        textoHint: 'Correo Electrónico',
                      ),
                      const SizedBox(height: 20),
                      const CampoTexto(
                        icono: Icons.lock,
                        textoHint: 'Nueva Contraseña',
                        esPassword: true,
                      ),
                      const SizedBox(height: 40),
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
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
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
        ],
      ),
    );
  }
}
