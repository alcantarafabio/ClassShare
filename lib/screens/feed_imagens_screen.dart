import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/postagem.dart';
import '../models/sala.dart';
import '../widgets/card_postagem.dart';
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

  Future<void> _excluirPost(Postagem post) async {
    await _dbHelper.deletePostagem(post.id!);
    _carregarPosts();
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
      itemBuilder: (context, index) => CardPostagem(
        post: _posts[index],
        onDelete: () => _excluirPost(_posts[index]),
      ),
    );
  }
}
