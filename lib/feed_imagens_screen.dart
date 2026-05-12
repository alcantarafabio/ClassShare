import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'database_helper.dart';
import 'dart:io'; // Para Mobile
import 'package:image_picker/image_picker.dart';

class FeedImagensScreen extends StatefulWidget {
  final Sala sala;
  const FeedImagensScreen({super.key, required this.sala});

  @override
  State<FeedImagensScreen> createState() => _FeedImagensScreenState();
}

class _FeedImagensScreenState extends State<FeedImagensScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _imagens = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _carregarImagens();
  }

  // Lógica para carregar as fotos do SQLite (Android) ou Mock (Web)
  Future<void> _carregarImagens() async {
    if (kIsWeb) {
      setState(() => _imagens = []);
    } else {
      try {
        final fotos = await _dbHelper.getImagens(widget.sala.id!);
        if (!mounted) return;
        setState(() => _imagens = fotos);
      } catch (e) {
        debugPrint("Erro ao carregar imagens: $e");
      }
    }
  }

  // Lógica para abrir a galeria e salvar o caminho no banco
  Future<void> _adicionarImagem() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Web, a integração seria via Firebase Storage.'),
        ),
      );
      return;
    }

    final XFile? imagemSelecionada = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Reduz o peso da imagem para o banco
    );

    if (imagemSelecionada != null) {
      await _dbHelper.insertImagem({
        'caminho': imagemSelecionada.path,
        'sala_id': widget.sala.id,
        'data': DateTime.now().toString(),
      });
      _carregarImagens(); // Atualiza a tela com a nova foto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFBCCEE0),
        title: Text(
          widget.sala.nome,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _imagens.isEmpty
          ? Center(
              child: Text(
                'Nenhuma imagem nesta sala ainda.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _imagens.length,
              itemBuilder: (context, index) {
                final String caminho = _imagens[index]['caminho'];

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? const Icon(Icons.image, color: Colors.grey)
                        : Image.file(
                            File(caminho),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF384755),
        onPressed: _adicionarImagem,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}
