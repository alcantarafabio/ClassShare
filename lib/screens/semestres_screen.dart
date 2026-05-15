import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/semestre.dart';
import '../widgets/card_semestre.dart';
import 'salas_screen.dart';

class SemestresScreen extends StatefulWidget {
  const SemestresScreen({super.key});

  @override
  State<SemestresScreen> createState() => _SemestresScreenState();
}

class _SemestresScreenState extends State<SemestresScreen> {
  final _dbHelper = DatabaseHelper();
  List<Semestre> _semestres = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarSemestres();
  }

  Future<void> _carregarSemestres() async {
    final dados = await _dbHelper.getSemestres();
    if (!mounted) return;
    setState(() {
      _semestres = dados;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semestres')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: _semestres.length,
              itemBuilder: (context, index) {
                final semestre = _semestres[index];
                return CardSemestre(
                  semestre: semestre,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SalasScreen(semestre: semestre),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
