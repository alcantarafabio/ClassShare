import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../models/sala.dart';

class FeedImagensScreen extends StatefulWidget {
  final Sala sala;
  const FeedImagensScreen({super.key, required this.sala});

  @override
  State<FeedImagensScreen> createState() => _FeedImagensScreenState();
}

class _FeedImagensScreenState extends State<FeedImagensScreen> {
  final _dbHelper = DatabaseHelper();
  final _picker = ImagePicker();
  List<Map<String, dynamic>> _imagens = [];

  @override
  void initState() {
    super.initState();
    _carregarImagens();
  }

  Future<void> _carregarImagens() async {
    final fotos = await _dbHelper.getImagens(widget.sala.id!);
    if (!mounted) return;
    setState(() => _imagens = fotos);
  }

  Future<void> _adicionarImagem() async {
    final imagem = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (imagem == null) return;

    await _dbHelper.insertImagem({
      'caminho': imagem.path,
      'sala_id': widget.sala.id,
      'data': DateTime.now().toIso8601String(),
    });
    _carregarImagens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.sala.nome)),
      body: _imagens.isEmpty
          ? Center(
              child: Text(
                'Nenhuma imagem nesta sala.\nToque + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _imagens.length,
              itemBuilder: (context, index) {
                final caminho = _imagens[index]['caminho'] as String;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    File(caminho),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarImagem,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
