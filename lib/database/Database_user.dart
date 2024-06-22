import 'package:parking/JSON/Parking.dart';
import 'package:parking/JSON/Users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUsuario {
  static final DatabaseUsuario _instance = DatabaseUsuario._internal();
  factory DatabaseUsuario() => _instance;

  DatabaseUsuario._internal();

  static Database? _database;
  final databaseName = "database.db";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Inicializa la base de datos y crea las tablas si no existen
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 2, // Incrementar la versión para activar onUpgrade
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users (userId INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT, parking TEXT, userName TEXT UNIQUE, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE parking(id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, placa TEXT UNIQUE, propietario TEXT, modelo TEXT, color TEXT, imagen BLOB)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS users (userId INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT, parking TEXT, userName TEXT UNIQUE, password TEXT)',
          );
        }
      },
    );
  }

  // Métodos para manejar la tabla de usuarios
  Future<bool> autenticar(Users usr) async {
    final db = await database;
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE userName = ? AND password = ?",
        [usr.userName, usr.password]);
    return result.isNotEmpty;
  }

  Future<int> createUser(Users usr) async {
    final db = await database;
    return db.insert("users", usr.toMap());
  }

  Future<Users?> getUser(String userName) async {
    final db = await database;
    var res = await db.query("users", where: "userName = ?", whereArgs: [userName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  Future<int> deleteUser(String userName) async {
    final db = await database;
    return db.delete("users", where: "userName = ?", whereArgs: [userName]);
  }

  Future<int> updateUser(Users user) async {
    final db = await database;
    return db.update("users", user.toMap(), where: "userName = ?", whereArgs: [user.userName]);
  }

  // Métodos para manejar la tabla de autos parqueados
  Future<int> createParking(Parking prk, int userId) async {
    final db = await database;
    var data = prk.toMap();
    data['userId'] = userId; // Añadir userId al mapa de datos
    return db.insert("parking", data);
  }

  Future<Parking?> getParking(String placa, int userId) async {
    final db = await database;
    var res = await db.query("parking", where: "placa = ? AND userId = ?", whereArgs: [placa, userId]);
    return res.isNotEmpty ? Parking.fromMap(res.first) : null;
  }

  // Retornar los datos como una lista filtrados por userId
  Future<List<Parking>> getParkingData(int userId) async {
    final db = await database;
    var res = await db.query("parking", where: "userId = ?", whereArgs: [userId]);
    List<Parking> list = res.isNotEmpty ? res.map((c) => Parking.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> deleteParking(String placa, int userId) async {
    final db = await database;
    return db.delete("parking", where: "placa = ? AND userId = ?", whereArgs: [placa, userId]);
  }

  

  Future<void> closeDB() async {
    final db = await database;
    await db.close();
  }
}
