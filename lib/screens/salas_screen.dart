import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/sala.dart';
import '../theme/app_theme.dart';
import 'feed_imagens_screen.dart';

class SalasScreen extends StatefulWidget {
  const SalasScreen({super.key});

  @override
  State<SalasScreen> createState() => _SalasScreenState();
}

class _SalasScreenState extends State<SalasScreen> {
  final _dbHelper = DatabaseHelper();
  List<Sala> _salas = [];

  @override
  void initState() {
    super.initState();
    _carregarSalas();
  }

  Future<void> _carregarSalas() async {
    final dados = await _dbHelper.getSalas();
    if (!mounted) return;
    setState(() => _salas = dados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Turmas')),
      body: _salas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _salas.length,
              itemBuilder: (context, index) {
                final sala = _salas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.class_, color: AppTheme.primary),
                    title: Text(sala.nome),
                    subtitle: const Text('Toque para ver as imagens'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FeedImagensScreen(sala: sala),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
