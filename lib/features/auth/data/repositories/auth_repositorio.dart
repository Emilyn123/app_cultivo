import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/database_service.dart';

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
      final respuesta = await _supabase.auth.signInWithPassword(
        email: correo.trim(),
        password: password.trim(),
      );

      // Si el login en la nube fue exitoso, lo guardamos localmente en SQLite
      if (respuesta.user != null) {
        await DatabaseService.instance.guardarSesionLocal(
          respuesta.user!.id,
          correo,
          'Agricultor', // O extraer el nombre de la DB
        );
      }
      return null;
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

  // 5. ACTUALIZAR PERFIL Y CONTRASEÑA
  Future<String?> actualizarPerfilYPassword({
    String? nuevoNombre,
    String? nuevaPassword,
  }) async {
    try {
      // 1. Obtener la sesión activa
      final usuarioActual = _supabase.auth.currentUser;
      if (usuarioActual == null) return 'No hay una sesión activa';

      // 2. Actualizar CONTRASEÑA en la bóveda de Supabase Auth
      if (nuevaPassword != null && nuevaPassword.trim().isNotEmpty) {
        await _supabase.auth.updateUser(
          UserAttributes(password: nuevaPassword.trim()),
        );
      }

      // 3. Actualizar NOMBRE en Supabase (PostgreSQL) y en SQLite (Local)
      if (nuevoNombre != null && nuevoNombre.trim().isNotEmpty) {
        final nombreLimpio = nuevoNombre.trim();

        // A. Nube: Actualiza tu tabla relacional pública
        await _supabase
            .from('usuario')
            .update({'nombre_completo': nombreLimpio})
            .eq('id_usuario', usuarioActual.id);

        // B. Local: Actualiza la tabla 'sesion_activa' en el celular
        await DatabaseService.instance.actualizarNombreSesionLocal(
          nombreLimpio,
        );
      }

      return null; // Éxito
    } on AuthException catch (e) {
      return e.message; // Errores de Supabase (ej. contraseña muy corta)
    } catch (e) {
      return 'Ocurrió un error al actualizar los datos';
    }
  }

  // 4. CERRAR SESIÓN
  Future<void> cerrarSesion() async {
    await _supabase.auth.signOut();
    await DatabaseService.instance.cerrarSesionLocal();
  }
}
