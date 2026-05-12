import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/sala.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'classshare.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE salas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)',
        );
        await db.execute(
          'CREATE TABLE imagens(id INTEGER PRIMARY KEY AUTOINCREMENT, caminho TEXT, sala_id INTEGER, data TEXT)',
        );
        // Salas de exemplo para o primeiro acesso
        await db.insert('salas', {'nome': 'Computação Móvel'});
        await db.insert('salas', {'nome': 'P.O.T.A'});
      },
    );
  }

  Future<List<Sala>> getSalas() async {
    final db = await database;
    final maps = await db.query('salas');
    return maps.map((m) => Sala.fromMap(m)).toList();
  }

  Future<int> insertSala(String nome) async {
    final db = await database;
    return db.insert('salas', {'nome': nome});
  }

  Future<int> insertImagem(Map<String, dynamic> row) async {
    final db = await database;
    return db.insert('imagens', row);
  }

  Future<List<Map<String, dynamic>>> getImagens(int salaId) async {
    final db = await database;
    return db.query('imagens', where: 'sala_id = ?', whereArgs: [salaId]);
  }
}
