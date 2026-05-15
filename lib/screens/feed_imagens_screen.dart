import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/postagem.dart';
import '../models/sala.dart';
import 'nova_postagem_screen.dart';

class FeedImagensScreen extends StatefulWidget {
  final Sala sala;
  const FeedImagensScreen({super.key, required this.sala});

  @override
  State<FeedImagensScreen> createState() => _FeedImagensScreenState();
}

class _FeedImagensScreenState extends State<FeedImagensScreen> {
  final _dbHelper = DatabaseHelper();
  List<Postagem> _posts = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPosts();
  }

  Future<void> _carregarPosts() async {
    final dados = await _dbHelper.getPostagens(widget.sala.id!);
    if (!mounted) return;
    setState(() {
      _posts = dados;
      _carregando = false;
    });
  }

  String _formatarData(String isoDate) {
    final d = DateTime.parse(isoDate);
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.sala.nome)),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NovaPostagemScreen(sala: widget.sala),
            ),
          );
          _carregarPosts();
        },
        icon: const Icon(Icons.add_photo_alternate),
        label: const Text('Nova Postagem'),
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Nenhuma postagem ainda.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Toque em "Nova Postagem" para começar.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _posts.length,
      itemBuilder: (context, index) => _CardPost(
        post: _posts[index],
        formatarData: _formatarData,
      ),
    );
  }
}

class _CardPost extends StatelessWidget {
  final Postagem post;
  final String Function(String) formatarData;

  const _CardPost({required this.post, required this.formatarData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem da postagem
          Image.file(
            File(post.caminhoImagem),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
              ),
            ),
          ),
          // Título, descrição e data
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (post.descricao.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    post.descricao,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  formatarData(post.data),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
