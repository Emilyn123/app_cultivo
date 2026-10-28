class Usuario {
  String nombre;
  String correo;
  String contrasena;
  DateTime fechaRegistro;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.contrasena,
    DateTime? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();
}
