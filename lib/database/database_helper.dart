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
      version: 2,
      onCreate: _criar,
      onUpgrade: _migrar,
    );
  }

  // Chamado apenas no primeiro acesso (banco não existe ainda)
  Future<void> _criar(Database db, int version) async {
    await db.execute(
      'CREATE TABLE salas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE imagens('
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  caminho TEXT NOT NULL,'
      '  sala_id INTEGER NOT NULL,'
      '  data TEXT NOT NULL'
      ')',
    );
    await _inserirSalasIniciais(db);
  }

  // Chamado quando a versão do banco aumenta
  Future<void> _migrar(Database db, int versaoAntiga, int versaoNova) async {
    if (versaoAntiga < 2) {
      // Substitui as salas de teste pelas disciplinas corretas
      await db.delete('salas');
      await _inserirSalasIniciais(db);
    }
  }

  Future<void> _inserirSalasIniciais(Database db) async {
    final salas = [
      'Computação para Dispositivos Móveis',
      'Pesquisa, Ordenação e Técnicas de Armazenamento',
      'Banco de Dados Aplicado a Big Data',
      'Técnicas de Machine Learning',
    ];
    for (final nome in salas) {
      await db.insert('salas', {'nome': nome});
    }
  }

  // ── Salas ──────────────────────────────────────────────────────────────────

  Future<List<Sala>> getSalas() async {
    final db = await database;
    final maps = await db.query('salas', orderBy: 'nome ASC');
    return maps.map((m) => Sala.fromMap(m)).toList();
  }

  Future<int> insertSala(String nome) async {
    final db = await database;
    return db.insert('salas', {'nome': nome});
  }

  Future<void> deleteSala(int id) async {
    final db = await database;
    // Remove as imagens vinculadas antes de deletar a sala
    await db.delete('imagens', where: 'sala_id = ?', whereArgs: [id]);
    await db.delete('salas', where: 'id = ?', whereArgs: [id]);
  }

  // ── Imagens ────────────────────────────────────────────────────────────────

  Future<int> insertImagem(Map<String, dynamic> row) async {
    final db = await database;
    return db.insert('imagens', row);
  }

  Future<List<Map<String, dynamic>>> getImagens(int salaId) async {
    final db = await database;
    return db.query(
      'imagens',
      where: 'sala_id = ?',
      whereArgs: [salaId],
      orderBy: 'data DESC',
    );
  }
}
