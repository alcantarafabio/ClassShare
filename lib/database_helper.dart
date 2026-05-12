import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Modelo de dados para a Sala
class Sala {
  final int? id;
  final String nome;

  Sala({this.id, required this.nome});

  // Converte um Map do banco para um objeto Sala
  factory Sala.fromMap(Map<String, dynamic> json) =>
      Sala(id: json['id'], nome: json['nome']);
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'banco_imagens.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE salas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)',
        );
        await db.execute(
          'CREATE TABLE imagens(id INTEGER PRIMARY KEY AUTOINCREMENT, caminho TEXT, sala_id INTEGER, data TEXT)',
        );

        // Dados iniciais para o professor ver algo na tela
        await db.insert('salas', {'nome': 'Computação Móvel'});
        await db.insert('salas', {'nome': 'P.O.T.A'});
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE imagens(id INTEGER PRIMARY KEY AUTOINCREMENT, caminho TEXT, sala_id INTEGER, data TEXT)',
          );
        }
      },
    );
  }

  // --- MÉTODOS PARA AS SALAS (O que estava faltando para o salas_screen) ---

  Future<List<Sala>> getSalas() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('salas');
    return List.generate(maps.length, (i) => Sala.fromMap(maps[i]));
  }

  Future<int> insertSala(String nome) async {
    Database db = await database;
    return await db.insert('salas', {'nome': nome});
  }

  // --- MÉTODOS PARA AS IMAGENS ---

  Future<int> insertImagem(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('imagens', row);
  }

  Future<List<Map<String, dynamic>>> getImagens(int salaId) async {
    Database db = await database;
    return await db.query('imagens', where: 'sala_id = ?', whereArgs: [salaId]);
  }
}
