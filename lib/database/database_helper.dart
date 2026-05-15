import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/postagem.dart';
import '../models/sala.dart';
import '../models/semestre.dart';

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
      version: 3,
      onCreate: _criar,
      onUpgrade: _migrar,
    );
  }

  // ── Primeiro acesso: banco não existia ────────────────────────────────────

  Future<void> _criar(Database db, int version) async {
    await db.execute(
      'CREATE TABLE semestres(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE salas('
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  nome TEXT NOT NULL,'
      '  semestre_id INTEGER NOT NULL'
      ')',
    );
    await db.execute(
      'CREATE TABLE posts('
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  titulo TEXT NOT NULL,'
      '  descricao TEXT,'
      '  caminho_imagem TEXT NOT NULL,'
      '  sala_id INTEGER NOT NULL,'
      '  data TEXT NOT NULL'
      ')',
    );
    await _inserirDadosIniciais(db);
  }

  // ── Migração: banco já existia em versão anterior ─────────────────────────

  Future<void> _migrar(Database db, int versaoAntiga, int versaoNova) async {
    if (versaoAntiga < 3) {
      // 1. Cria tabela de semestres
      await db.execute(
        'CREATE TABLE IF NOT EXISTS semestres('
        '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '  nome TEXT NOT NULL'
        ')',
      );

      // 2. Insere os semestres em ordem — 4º semestre receberá id=4
      for (int i = 1; i <= 5; i++) {
        await db.insert('semestres', {'nome': '$iº Semestre'});
      }

      // 3. Adiciona coluna semestre_id à tabela salas existente
      await db.execute('ALTER TABLE salas ADD COLUMN semestre_id INTEGER');

      // 4. Associa todas as disciplinas existentes ao 4º semestre
      await db.update('salas', {'semestre_id': 4});

      // 5. Cria tabela de postagens (substitui a tabela imagens)
      await db.execute(
        'CREATE TABLE posts('
        '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '  titulo TEXT NOT NULL,'
        '  descricao TEXT,'
        '  caminho_imagem TEXT NOT NULL,'
        '  sala_id INTEGER NOT NULL,'
        '  data TEXT NOT NULL'
        ')',
      );

      // 6. Remove tabela antiga que não é mais usada
      await db.execute('DROP TABLE IF EXISTS imagens');
    }
  }

  Future<void> _inserirDadosIniciais(Database db) async {
    // Semestres inseridos em ordem: id 1→"1º", 2→"2º", ..., 4→"4º", 5→"5º"
    for (int i = 1; i <= 5; i++) {
      await db.insert('semestres', {'nome': '$iº Semestre'});
    }

    final disciplinas = [
      'Computação para Dispositivos Móveis',
      'Pesquisa, Ordenação e Técnicas de Armazenamento',
      'Banco de Dados Aplicado a Big Data',
      'Técnicas de Machine Learning',
    ];
    for (final nome in disciplinas) {
      await db.insert('salas', {'nome': nome, 'semestre_id': 4});
    }
  }

  // ── Semestres ─────────────────────────────────────────────────────────────

  Future<List<Semestre>> getSemestres() async {
    final db = await database;
    final maps = await db.query('semestres', orderBy: 'id ASC');
    return maps.map((m) => Semestre.fromMap(m)).toList();
  }

  // ── Salas ─────────────────────────────────────────────────────────────────

  Future<List<Sala>> getSalasPorSemestre(int semestreId) async {
    final db = await database;
    final maps = await db.query(
      'salas',
      where: 'semestre_id = ?',
      whereArgs: [semestreId],
      orderBy: 'nome ASC',
    );
    return maps.map((m) => Sala.fromMap(m)).toList();
  }

  Future<int> insertSala(String nome, int semestreId) async {
    final db = await database;
    return db.insert('salas', {'nome': nome, 'semestre_id': semestreId});
  }

  Future<void> deleteSala(int id) async {
    final db = await database;
    // Remove as postagens vinculadas antes de deletar a sala
    await db.delete('posts', where: 'sala_id = ?', whereArgs: [id]);
    await db.delete('salas', where: 'id = ?', whereArgs: [id]);
  }

  // ── Postagens ─────────────────────────────────────────────────────────────

  Future<List<Postagem>> getPostagens(int salaId) async {
    final db = await database;
    final maps = await db.query(
      'posts',
      where: 'sala_id = ?',
      whereArgs: [salaId],
      orderBy: 'data DESC',
    );
    return maps.map((m) => Postagem.fromMap(m)).toList();
  }

  Future<int> insertPostagem(Map<String, dynamic> row) async {
    final db = await database;
    return db.insert('posts', row);
  }
}
