import 'dart:io';
import 'package:flutter/material.dart';
import '../models/postagem.dart';
import '../screens/postagem_detalhe_screen.dart';

class CardPostagem extends StatelessWidget {
  final Postagem post;
  final VoidCallback onDelete;

  const CardPostagem({super.key, required this.post, required this.onDelete});

  String _formatarData(String isoDate) {
    final d = DateTime.parse(isoDate);
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Postagem'),
        content: Text('Deseja excluir "${post.titulo}"?'),
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
    if (confirmado == true) onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostagemDetalheScreen(post: post),
          ),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImagemPost(caminho: post.caminhoImagem),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.titulo,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (post.descricao.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          post.descricao,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        _formatarData(post.data),
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  tooltip: 'Excluir postagem',
                  onPressed: () => _confirmarExclusao(context),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _ImagemPost extends StatelessWidget {
  final String caminho;
  const _ImagemPost({required this.caminho});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(caminho),
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 200,
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Imagem não disponível',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
