import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositorio {
  // Instancia del cliente de Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. REGISTRO DE USUARIO
  Future<String?> registrarUsuario({
    required String nombreCompleto,
    required String correo,
    required String password,
  }) async {
    try {
      print("--> INTENTANDO REGISTRAR EN SUPABASE: $correo");
      // Registrar la cuenta en el sistema de autenticación de Supabase
      final AuthResponse respuesta = await _supabase.auth.signUp(
        email: correo.trim(),
        password: password.trim(),
      );

      final User? usuario = respuesta.user;
      print("--> RESPUESTA AUTH RECIBIDA. Usuario ID: ${usuario?.id}");

      if (usuario != null) {
        // Insertar en la tabla 'usuario' creada en Supabase
        print("--> INSERTANDO EN TABLA USUARIO...");
        await _supabase.from('usuario').insert({
          'id_usuario': usuario.id,
          'nombre_completo': nombreCompleto.trim(),
          'correo': correo.trim(),
        });
        print("--> INSERCIÓN EN TABLA EXITOSA");
      }
      return null; // Éxito (sin errores)
    } on AuthException catch (e) {
      print("--> ERROR AUTH EXCEPTION: ${e.message}");
      return e.message; // Mensaje de error provisto por Supabase
    } catch (e) {
      print("--> ERROR INESPERADO: $e");
      return 'Ocurrió un error inesperado al registrar el usuario';
    }
  }

  // 2. INICIO DE SESIÓN
  Future<String?> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: correo.trim(),
        password: password.trim(),
      );
      return null; // Login exitoso
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ocurrió un error al iniciar sesión';
    }
  }

  // 3. OLVIDASTE TU CONTRASEÑA
  Future<String?> restablecerPassword({required String correo}) async {
    try {
      print("--> SOLICITANDO RECUPERACIÓN PARA: $correo");
      await _supabase.auth.resetPasswordForEmail(correo.trim());
      print("--> PETICIÓN ACEPTADA POR SUPABASE");
      return null; // Correo de restablecimiento enviado con éxito
    } on AuthException catch (e) {
      print("--> ERROR SUPABASE AUTH: ${e.message}");
      return e.message;
    } catch (e) {
      print("--> ERROR INESPERADO: $e");
      return 'Error al enviar el correo de recuperación';
    }
  }

  // 4. CERRAR SESIÓN
  Future<void> cerrarSesion() async {
    await _supabase.auth.signOut();
  }
}
