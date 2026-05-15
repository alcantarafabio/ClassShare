import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../models/sala.dart';
import '../theme/app_theme.dart';

class NovaPostagemScreen extends StatefulWidget {
  final Sala sala;
  const NovaPostagemScreen({super.key, required this.sala});

  @override
  State<NovaPostagemScreen> createState() => _NovaPostagemScreenState();
}

class _NovaPostagemScreenState extends State<NovaPostagemScreen> {
  final _dbHelper = DatabaseHelper();
  final _picker = ImagePicker();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  String? _caminhoImagem;
  bool _salvando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    final imagem = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (imagem != null) {
      setState(() => _caminhoImagem = imagem.path);
    }
  }

  Future<void> _salvar() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um título para a postagem.')),
      );
      return;
    }

    if (_caminhoImagem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma imagem da galeria.')),
      );
      return;
    }

    setState(() => _salvando = true);

    await _dbHelper.insertPostagem({
      'titulo': titulo,
      'descricao': _descricaoController.text.trim(),
      'caminho_imagem': _caminhoImagem!,
      'sala_id': widget.sala.id,
      'data': DateTime.now().toIso8601String(),
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Postagem')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Área de seleção da imagem
            GestureDetector(
              onTap: _selecionarImagem,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _caminhoImagem != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_caminhoImagem!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 52,
                            color: AppTheme.primary,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Toque para selecionar uma imagem',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            if (_caminhoImagem != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _selecionarImagem,
                icon: const Icon(Icons.refresh),
                label: const Text('Trocar imagem'),
              ),
            ],
            const SizedBox(height: 20),

            // Título
            TextField(
              controller: _tituloController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Descrição
            TextField(
              controller: _descricaoController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Botão Salvar
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: _salvando ? null : _salvar,
                icon: _salvando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_salvando ? 'Salvando...' : 'Salvar Postagem'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
