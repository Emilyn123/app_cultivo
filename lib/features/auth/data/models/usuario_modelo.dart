class UsuarioModelo {
  final String idUsuario;
  final String nombreCompleto;
  final String correo;
  final DateTime? fechaRegistro;

  UsuarioModelo({
    required this.idUsuario,
    required this.nombreCompleto,
    required this.correo,
    this.fechaRegistro,
  });

  // Convierte un Map (JSON de Supabase) a una instancia de UsuarioModelo
  factory UsuarioModelo.fromMap(Map<String, dynamic> mapa) {
    return UsuarioModelo(
      idUsuario: mapa['id_usuario'] ?? '',
      nombreCompleto: mapa['nombre_completo'] ?? '',
      correo: mapa['correo'] ?? '',
      fechaRegistro: mapa['fecha_registro'] != null
          ? DateTime.tryParse(mapa['fecha_registro'].toString())
          : null,
    );
  }

  // Convierte la instancia a un Map para enviar a Supabase
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nombre_completo': nombreCompleto,
      'correo': correo,
    };
  }
}
