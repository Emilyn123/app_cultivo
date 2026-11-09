import 'package:flutter/material.dart';
import '../../data/repositories/auth_repositorio.dart';

class AuthController extends ChangeNotifier {
  final AuthRepositorio _authRepositorio = AuthRepositorio();

  bool _cargando = false;
  String? _mensajeError;

  bool get cargando => _cargando;
  String? get mensajeError => _mensajeError;

  // 1. Manejo del estado para Registro
  Future<bool> registrar({
    required String nombreCompleto,
    required String correo,
    required String password,
  }) async {
    _cargando = true;
    _mensajeError = null;
    notifyListeners();

    print("--> [AuthController] Iniciando registro para: $correo");

    final error = await _authRepositorio.registrarUsuario(
      nombreCompleto: nombreCompleto,
      correo: correo,
      password: password,
    );

    print("--> [AuthController] Resultado de error: $error");

    _cargando = false;
    _mensajeError = error;
    notifyListeners();

    return error == null;
  }

  // 2. Manejo del estado para Iniciar Sesión
  Future<bool> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    _cargando = true;
    _mensajeError = null;
    notifyListeners();

    final error = await _authRepositorio.iniciarSesion(
      correo: correo,
      password: password,
    );

    _cargando = false;
    _mensajeError = error;
    notifyListeners();

    return error == null;
  }

  // 3. Manejo del estado para Recuperar Contraseña
  Future<bool> recuperarContrasena({required String correo}) async {
    _cargando = true;
    _mensajeError = null;
    notifyListeners();

    final error = await _authRepositorio.restablecerPassword(correo: correo);

    _cargando = false;
    _mensajeError = error;
    notifyListeners();

    return error == null;
  }
}
