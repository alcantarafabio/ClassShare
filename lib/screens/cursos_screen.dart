import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/curso.dart';
import '../widgets/card_curso.dart';
import 'semestres_screen.dart';

class CursosScreen extends StatefulWidget {
const CursosScreen({super.key});

@override
State<CursosScreen> createState() => _CursosScreenState();
}

class _CursosScreenState extends State<CursosScreen> {
final _dbHelper = DatabaseHelper();
List<Curso> _cursos = [];
bool _carregando = true;

@override
void initState() {
super.initState();
_carregarCursos();
}

Future<void> _carregarCursos() async {
final dados = await _dbHelper.getCursos();


if (!mounted) return;

setState(() {
  _cursos = dados;
  _carregando = false;
});


}

Future<void> _mostrarDialogAdicionar() async {
String nomeCurso = '';


final confirmado = await showDialog<bool>(
  context: context,
  builder: (ctx) => AlertDialog(
    scrollable: true,
    title: const Text('Novo Curso'),
    content: TextField(
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Nome do curso',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => nomeCurso = value,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(ctx, false),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(ctx, true),
        child: const Text('Adicionar'),
      ),
    ],
  ),
);

if (!mounted) return;

if (confirmado == true && nomeCurso.trim().isNotEmpty) {
  await _dbHelper.insertCurso(nomeCurso.trim());

  if (!mounted) return;

  _carregarCursos();
}


}

Future<void> _mostrarDialogExcluir(Curso curso) async {
final confirmado = await showDialog<bool>(
context: context,
builder: (ctx) => AlertDialog(
scrollable: true,
title: const Text('Excluir Curso'),
content: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Deseja excluir "${curso.nome}"?'),
const SizedBox(height: 4),
const Text(
'Os semestres e disciplinas deste curso também serão removidos.',
style: TextStyle(fontSize: 12, color: Colors.grey),
),
],
),
actions: [
TextButton(
onPressed: () => Navigator.pop(ctx, false),
child: const Text('Cancelar'),
),
FilledButton(
style: FilledButton.styleFrom(
backgroundColor: Colors.redAccent,
),
onPressed: () => Navigator.pop(ctx, true),
child: const Text('Excluir'),
),
],
),
);


if (!mounted) return;

if (confirmado == true) {
  await _dbHelper.deleteCurso(curso.id!);

  if (!mounted) return;

  _carregarCursos();
}


}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Cursos'),
),
body: _buildBody(),
floatingActionButton: FloatingActionButton.extended(
onPressed: _mostrarDialogAdicionar,
icon: const Icon(Icons.add),
label: const Text('Novo Curso'),
),
);
}

Widget _buildBody() {
if (_carregando) {
return const Center(
child: CircularProgressIndicator(),
);
}


if (_cursos.isEmpty) {
  return const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.school_outlined,
          size: 64,
          color: Colors.grey,
        ),
        SizedBox(height: 12),
        Text(
          'Nenhum curso cadastrado.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Toque em "Novo Curso" para começar.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

return ListView.builder(
  padding: const EdgeInsets.only(
    top: 8,
    bottom: 80,
  ),
  itemCount: _cursos.length,
  itemBuilder: (context, index) {
    final curso = _cursos[index];

    return CardCurso(
      curso: curso,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SemestresScreen(
            curso: curso,
          ),
        ),
      ),
      onDelete: () => _mostrarDialogExcluir(curso),
    );
  },
);

}
}
