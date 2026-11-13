import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Patrón Singleton para mantener una única conexión en toda la app
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('agri_soil_local.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Creación de la tabla local para recordar la sesión
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE sesion_activa (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_usuario_remoto TEXT NOT NULL,
      correo TEXT NOT NULL,
      nombre_completo TEXT,
      fecha_login TEXT NOT NULL
    )
    ''');
  }

  // Método para guardar el usuario localmente cuando hace login exitoso
  Future<void> guardarSesionLocal(
    String idUsuario,
    String correo,
    String nombre,
  ) async {
    final db = await instance.database;
    // Borramos cualquier sesión anterior
    await db.delete('sesion_activa');

    // Guardamos la nueva sesión
    await db.insert('sesion_activa', {
      'id_usuario_remoto': idUsuario,
      'correo': correo,
      'nombre_completo': nombre,
      'fecha_login': DateTime.now().toIso8601String(),
    });
  }

  // Método para verificar si ya existe una sesión guardada (Para el Auto-Login offline)
  Future<bool> existeSesionLocal() async {
    final db = await instance.database;
    final resultado = await db.query('sesion_activa', limit: 1);
    return resultado.isNotEmpty;
  }
}
