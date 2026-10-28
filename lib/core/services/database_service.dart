import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  // Permite conectarnos a la base de datos desde cualquier parte de la app
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('agri_soil.db');
    return _database!;
  }

  // Inicializa SQLite y ubica dónde guardar el archivo en la memoria del celular
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Abre la base de datos y crea las tablas si es la primera vez
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 1. CREACIÓN DE LAS TABLAS SOLICITADAS EN LA GUÍA TÉCNICA
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const intType = 'INTEGER DEFAULT 0';

    // Tabla de Mediciones del Sensor (ESP32)
    await db.execute('''
CREATE TABLE soil_measurements (
  id $idType,
  remote_id TEXT UNIQUE NOT NULL,
  ph $realType,
  moisture $realType,
  temperature $realType,
  conductivity $realType,
  measured_at $textType,
  is_synced $intType
)
''');

    // Tabla de Cultivos Activos
    await db.execute('''
CREATE TABLE active_crops (
  id $idType,
  crop_name $textType,
  current_stage INTEGER DEFAULT 1,
  started_at $textType
)
''');
  }

  // 2. FUNCIONES PARA LEER Y GUARDAR DATOS (Ejemplo básico)
  // Cerrar la base de datos de forma segura
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
