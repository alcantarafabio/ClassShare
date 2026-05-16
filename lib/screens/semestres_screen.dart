import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/curso.dart';
import '../models/semestre.dart';
import '../widgets/card_semestre.dart';
import 'salas_screen.dart';

class SemestresScreen extends StatefulWidget {
  final Curso curso;
  const SemestresScreen({super.key, required this.curso});

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
    final dados = await _dbHelper.getSemestresPorCurso(widget.curso.id!);
    if (!mounted) return;
    setState(() {
      _semestres = dados;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.curso.nome),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text(
                'Selecione um semestre',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _semestres.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Nenhum semestre encontrado.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
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
