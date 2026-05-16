import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../theme/app_theme.dart';

class CardCurso extends StatelessWidget {
  final Curso curso;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CardCurso({
    super.key,
    required this.curso,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const CircleAvatar(
          backgroundColor: AppTheme.primary,
          child: Icon(Icons.school, color: Colors.white, size: 20),
        ),
        title: Text(
          curso.nome,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: const Text('Toque para ver os semestres'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          tooltip: 'Excluir curso',
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
