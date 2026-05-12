import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importante para reconhecer a classe Sala e o Helper
import 'feed_imagens_screen.dart';

class SalasScreen extends StatefulWidget {
  const SalasScreen({super.key});

  @override
  State<SalasScreen> createState() => _SalasScreenState();
}

class _SalasScreenState extends State<SalasScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Sala> _salas = []; // Agora é uma lista de Objetos Sala, não mais Maps

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  Future<void> _atualizarLista() async {
    final dados = await _dbHelper.getSalas();
    if (!mounted) return;
    setState(() {
      _salas = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Turmas - CDM',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF384755),
      ),
      body: _salas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _salas.length,
              itemBuilder: (context, index) {
                final sala = _salas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.class_, color: Color(0xFF384755)),
                    title: Text(sala.nome), // Acesso via objeto: sala.nome
                    subtitle: const Text('Clique para ver o banco de imagens'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedImagensScreen(sala: sala),
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
