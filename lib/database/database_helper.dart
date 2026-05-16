import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/curso.dart';
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
      version: 4,
      onCreate: _criar,
      onUpgrade: _migrar,
    );
  }

  // ── Primeiro acesso: banco não existia ────────────────────────────────────

  Future<void> _criar(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cursos(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE semestres('
      '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
      '  nome TEXT NOT NULL,'
      '  curso_id INTEGER NOT NULL'
      ')',
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
      await db.execute(
        'CREATE TABLE IF NOT EXISTS semestres('
        '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '  nome TEXT NOT NULL'
        ')',
      );
      for (int i = 1; i <= 5; i++) {
        await db.insert('semestres', {'nome': '$iº Semestre'});
      }
      await db.execute('ALTER TABLE salas ADD COLUMN semestre_id INTEGER');
      await db.update('salas', {'semestre_id': 4});
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
      await db.execute('DROP TABLE IF EXISTS imagens');
    }

    if (versaoAntiga < 4) {
      // Cria tabela de cursos
      await db.execute(
        'CREATE TABLE IF NOT EXISTS cursos('
        '  id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '  nome TEXT NOT NULL'
        ')',
      );

      // Insere o curso ADS e guarda seu id
      final cursoId = await db.insert(
        'cursos',
        {'nome': 'Análise e Desenvolvimento de Sistemas (ADS)'},
      );

      // Adiciona coluna curso_id à tabela semestres
      await db.execute('ALTER TABLE semestres ADD COLUMN curso_id INTEGER');

      // Associa todos os semestres existentes ao curso ADS
      await db.update('semestres', {'curso_id': cursoId});
    }
  }

  Future<void> _inserirDadosIniciais(Database db) async {
    // Curso inicial: ADS
    final cursoId = await db.insert(
      'cursos',
      {'nome': 'Análise e Desenvolvimento de Sistemas (ADS)'},
    );

    // Semestres do curso ADS
    for (int i = 1; i <= 5; i++) {
      await db.insert('semestres', {'nome': '$iº Semestre', 'curso_id': cursoId});
    }

    // Disciplinas padrão no 4º semestre (id = 4)
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

  // ── Cursos ────────────────────────────────────────────────────────────────

  Future<List<Curso>> getCursos() async {
    final db = await database;
    final maps = await db.query('cursos', orderBy: 'id ASC');
    return maps.map((m) => Curso.fromMap(m)).toList();
  }

  Future<int> insertCurso(String nome) async {
    final db = await database;
    return db.insert('cursos', {'nome': nome});
  }

  Future<void> deleteCurso(int id) async {
    final db = await database;
    // Busca semestres do curso para deletar cascata
    final semestres = await db.query(
      'semestres',
      where: 'curso_id = ?',
      whereArgs: [id],
    );
    for (final s in semestres) {
      final semestreId = s['id'] as int;
      final salas = await db.query(
        'salas',
        where: 'semestre_id = ?',
        whereArgs: [semestreId],
      );
      for (final sala in salas) {
        await db.delete('posts', where: 'sala_id = ?', whereArgs: [sala['id']]);
      }
      await db.delete('salas', where: 'semestre_id = ?', whereArgs: [semestreId]);
    }
    await db.delete('semestres', where: 'curso_id = ?', whereArgs: [id]);
    await db.delete('cursos', where: 'id = ?', whereArgs: [id]);
  }

  // ── Semestres ─────────────────────────────────────────────────────────────

  Future<List<Semestre>> getSemestresPorCurso(int cursoId) async {
    final db = await database;
    final maps = await db.query(
      'semestres',
      where: 'curso_id = ?',
      whereArgs: [cursoId],
      orderBy: 'id ASC',
    );
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

  Future<void> deletePostagem(int id) async {
    final db = await database;
    await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }
}
