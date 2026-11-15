import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Patrón Singleton para mantener una única conexión en toda la app
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  static const String _sqlActiveCrops = '''
      CREATE TABLE IF NOT EXISTS active_crops (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_cultivo INTEGER NOT NULL,
        crop_name TEXT NOT NULL,
        nombre_muestra TEXT NOT NULL,
        current_stage INTEGER DEFAULT 1,
        started_at TEXT NOT NULL
      )
      ''';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('agri_soil_local.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
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

    await db.execute('''
    CREATE TABLE registros_manuales_pendientes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_cultivo_esperado INTEGER NOT NULL,
      nombre_muestra TEXT NOT NULL,
      estado TEXT NOT NULL,
      municipio TEXT NOT NULL,
      localidad TEXT NOT NULL,
      telefono TEXT,
      ph_medido REAL NOT NULL,
      humedad_medida REAL NOT NULL,
      temp_medida REAL NOT NULL,
      ce_medida REAL NOT NULL,
      fecha_registro TEXT NOT NULL,
      sincronizado INTEGER DEFAULT 0
    )
    ''');

    await db.execute(_sqlActiveCrops);
  }

  // MÉTODO NUEVO: Se ejecuta porque cambiamos la versión de 1 a 2
  // Esto obliga a crear la tabla que faltaba en los teléfonos que ya tenían la app instalada
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS registros_manuales_pendientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_cultivo_esperado INTEGER NOT NULL,
        nombre_muestra TEXT NOT NULL,
        estado TEXT NOT NULL,
        municipio TEXT NOT NULL,
        localidad TEXT NOT NULL,
        telefono TEXT,
        ph_medido REAL NOT NULL,
        humedad_medida REAL NOT NULL,
        temp_medida REAL NOT NULL,
        ce_medida REAL NOT NULL,
        fecha_registro TEXT NOT NULL,
        sincronizado INTEGER DEFAULT 0
      )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute(_sqlActiveCrops);
    }
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

  // Método para actualizar el nombre en la sesión local (Offline)
  Future<void> actualizarNombreSesionLocal(String nuevoNombre) async {
    final db = await instance.database;
    // Actualizamos la columna nombre_completo en la sesión activa
    await db.execute('UPDATE sesion_activa SET nombre_completo = ?', [
      nuevoNombre.trim(),
    ]);
  }

  // Método para obtener los datos del usuario logueado
  Future<Map<String, dynamic>?> obtenerDatosSesion() async {
    final db = await instance.database;
    final resultado = await db.query('sesion_activa', limit: 1);

    if (resultado.isNotEmpty) {
      return resultado.first;
    }
    return null;
  }

  // Método para borrar la sesión local al cerrar sesión
  Future<void> cerrarSesionLocal() async {
    final db = await instance.database;
    await db.delete('sesion_activa');
  }
}
