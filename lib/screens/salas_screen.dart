import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/sala.dart';
import '../models/semestre.dart';
import '../widgets/card_sala.dart';
import 'feed_imagens_screen.dart';

const String _senhaMestra = '1234';

class SalasScreen extends StatefulWidget {
  final Semestre semestre;
  const SalasScreen({super.key, required this.semestre});

  @override
  State<SalasScreen> createState() => _SalasScreenState();
}

class _SalasScreenState extends State<SalasScreen> {
  final _dbHelper = DatabaseHelper();
  List<Sala> _salas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarSalas();
  }

  Future<void> _carregarSalas() async {
    final dados = await _dbHelper.getSalasPorSemestre(widget.semestre.id!);
    if (!mounted) return;
    setState(() {
      _salas = dados;
      _carregando = false;
    });
  }

  // ── Adicionar disciplina ───────────────────────────────────────────────────

  Future<void> _mostrarDialogAdicionar() async {
    final controller = TextEditingController();

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Disciplina'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Nome da disciplina',
            border: OutlineInputBorder(),
          ),
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

    if (confirmado == true && controller.text.trim().isNotEmpty) {
      await _dbHelper.insertSala(controller.text.trim(), widget.semestre.id!);
      _carregarSalas();
    }
    controller.dispose();
  }

  // ── Excluir disciplina ─────────────────────────────────────────────────────

  Future<void> _mostrarDialogExcluir(Sala sala) async {
    final senhaController = TextEditingController();

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Disciplina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deseja excluir "${sala.nome}"?'),
            const SizedBox(height: 4),
            const Text(
              'As postagens desta disciplina também serão removidas.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              obscureText: true,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Senha mestra',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      if (senhaController.text == _senhaMestra) {
        await _dbHelper.deleteSala(sala.id!);
        _carregarSalas();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha incorreta. Exclusão cancelada.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
    senhaController.dispose();
  }

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.semestre.nome)),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogAdicionar,
        icon: const Icon(Icons.add),
        label: const Text('Nova Disciplina'),
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_salas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Nenhuma disciplina neste semestre.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Toque em "Nova Disciplina" para começar.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _salas.length,
      itemBuilder: (context, index) {
        final sala = _salas[index];
        return CardSala(
          sala: sala,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedImagensScreen(sala: sala),
            ),
          ),
          onDelete: () => _mostrarDialogExcluir(sala),
        );
      },
    );
  }
}
